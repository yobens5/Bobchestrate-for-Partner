#!/usr/bin/env python3
"""
Load SuperChampion CSVs into IBM Db2 on Cloud.
Reads connection details from .db2.json in the same directory.
Usage: python load_to_db2.py [--workers N]   (default: 4)

Rows are inserted with ibm_db.execute_many() — each batch of BATCH_SIZE rows
is sent in a SINGLE array-insert round-trip instead of one round-trip per row.
Against a remote Db2 (this instance lives in Tokyo) that is the difference
between hours and minutes.
"""

import base64
import csv
import ibm_db
import json
import os
import sys
import tempfile
import time
import threading
from concurrent.futures import ThreadPoolExecutor, as_completed

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
CREDS_FILE = os.path.join(SCRIPT_DIR, ".db2.json")
CSV_DIR    = os.path.join(SCRIPT_DIR, "csv")
DDL_FILE   = os.path.join(SCRIPT_DIR, "ddl", "superchampion_db2_ddl.sql")
# Rows per array-insert round-trip. Larger = fewer round-trips = faster over a
# high-latency link; the biggest CSV is only ~24 MB so memory is a non-issue.
BATCH_SIZE = 5000

# Dims first so FK-aware tooling is happy; facts + marts can run in parallel
# Each tuple: (csv_file, schema, table)
TABLES = [
    ("dwh.dim_date.csv",                    "DWH",  "DIM_DATE"),
    ("dwh.dim_store.csv",                   "DWH",  "DIM_STORE"),
    ("dwh.dim_product.csv",                 "DWH",  "DIM_PRODUCT"),
    ("dwh.dim_employee.csv",                "DWH",  "DIM_EMPLOYEE"),
    ("mart.daily_store_sales.csv",          "MART", "DAILY_STORE_SALES"),
    ("mart.monthly_store_pnl.csv",          "MART", "MONTHLY_STORE_PNL"),
    ("mart.category_monthly_sales.csv",     "MART", "CATEGORY_MONTHLY_SALES"),
    ("mart.store_labor_monthly.csv",        "MART", "STORE_LABOR_MONTHLY"),
    ("mart.inventory_health_current.csv",   "MART", "INVENTORY_HEALTH_CURRENT"),
    ("mart.monthly_chain_kpi.csv",          "MART", "MONTHLY_CHAIN_KPI"),
    ("dwh.fact_sales.csv",                  "DWH",  "FACT_SALES"),
    ("dwh.fact_inventory_snapshot.csv",     "DWH",  "FACT_INVENTORY_SNAPSHOT"),
    ("dwh.fact_employee_shift.csv",         "DWH",  "FACT_EMPLOYEE_SHIFT"),
]

TRUNCATE_ORDER = [
    "MART.DAILY_STORE_SALES", "MART.MONTHLY_STORE_PNL", "MART.CATEGORY_MONTHLY_SALES",
    "MART.STORE_LABOR_MONTHLY", "MART.INVENTORY_HEALTH_CURRENT", "MART.MONTHLY_CHAIN_KPI",
    "DWH.FACT_SALES", "DWH.FACT_INVENTORY_SNAPSHOT", "DWH.FACT_EMPLOYEE_SHIFT",
    "DWH.DIM_DATE", "DWH.DIM_STORE", "DWH.DIM_PRODUCT", "DWH.DIM_EMPLOYEE",
]

# Thread-safe print lock
_print_lock = threading.Lock()


def tprint(msg):
    with _print_lock:
        print(msg)


def load_creds():
    with open(CREDS_FILE) as f:
        raw = f.read().strip()
    data = json.loads(raw)
    if isinstance(data, str):
        data = json.loads(data)
    db2      = data["connection"]["db2"]
    host     = db2["hosts"][0]["hostname"]
    port     = db2["hosts"][0]["port"]
    database = db2["database"]
    username = db2["authentication"]["username"]
    password = db2["authentication"]["password"]
    cert_b64 = db2["certificate"]["certificate_base64"]
    return host, port, database, username, password, cert_b64


def write_cert(cert_b64):
    cert_bytes = base64.b64decode(cert_b64)
    tmp = tempfile.NamedTemporaryFile(delete=False, suffix=".pem")
    tmp.write(cert_bytes)
    tmp.close()
    return tmp.name


def make_connection(host, port, database, username, password, cert_path):
    dsn = (
        f"DATABASE={database};"
        f"HOSTNAME={host};"
        f"PORT={port};"
        f"PROTOCOL=TCPIP;"
        f"UID={username};"
        f"PWD={password};"
        f"Security=SSL;"
        f"SSLServerCertificate={cert_path};"
    )
    return ibm_db.connect(dsn, "", "")


def run_ddl_and_truncate(conn):
    print("Creating schemas and tables...")
    with open(DDL_FILE) as f:
        ddl = f.read()
    for stmt in ddl.split(";"):
        stmt = stmt.strip()
        if stmt:
            try:
                ibm_db.exec_immediate(conn, stmt)
            except Exception as e:
                msg = str(e)
                if "already exists" in msg.lower() or "sql0601" in msg.lower() or "sql4918" in msg.lower():
                    pass
                else:
                    print(f"  DDL warning: {msg[:120]}")
    print("  Done.")

    print("Truncating existing data...")
    for table in TRUNCATE_ORDER:
        try:
            ibm_db.exec_immediate(conn, f"TRUNCATE TABLE {table} IMMEDIATE")
        except Exception:
            pass
    print("  Done.\n")


def load_table(csv_file, schema, table, host, port, database, username, password, cert_path):
    full_table = f"{schema}.{table}"
    csv_path   = os.path.join(CSV_DIR, csv_file)

    with open(csv_path, newline="", encoding="utf-8") as f:
        reader  = csv.reader(f)
        headers = next(reader)
        rows    = list(reader)

    if not rows:
        tprint(f"  {full_table}: empty, skipping.")
        return full_table, 0, 0.0

    conn = make_connection(host, port, database, username, password, cert_path)

    cols         = ", ".join(headers)
    placeholders = ", ".join(["?" for _ in headers])
    sql          = f"INSERT INTO {full_table} ({cols}) VALUES ({placeholders})"

    total      = len(rows)
    start_time = time.time()
    stmt       = ibm_db.prepare(conn, sql)
    ibm_db.autocommit(conn, False)

    loaded = 0
    for batch_start in range(0, total, BATCH_SIZE):
        batch = rows[batch_start : batch_start + BATCH_SIZE]
        # Empty string -> NULL, then push the WHOLE batch in one round-trip.
        params = tuple(
            tuple(v if v != "" else None for v in row)
            for row in batch
        )
        ibm_db.execute_many(stmt, params)
        ibm_db.commit(conn)
        loaded += len(batch)

        # thread-safe progress line
        pct    = 100 * loaded // total
        filled = int(30 * loaded / total)
        bar    = "█" * filled + "░" * (30 - filled)
        elapsed = time.time() - start_time
        eta    = int(elapsed * (total - loaded) / loaded) if loaded else 0
        with _print_lock:
            print(f"  {full_table:<35s} [{bar}] {pct:3d}%  {loaded:>7,}/{total:,}  ETA {eta:3d}s", flush=True)

    ibm_db.autocommit(conn, True)
    ibm_db.close(conn)

    elapsed = time.time() - start_time
    return full_table, total, elapsed


def main():
    workers = 4
    for i, arg in enumerate(sys.argv[1:]):
        if arg == "--workers" and i + 1 < len(sys.argv[1:]):
            workers = int(sys.argv[i + 2])

    print("=== SuperChampion → Db2 Loader ===\n")

    host, port, database, username, password, cert_b64 = load_creds()
    print(f"Connecting to {host}:{port}/{database} as {username}...")

    cert_path = write_cert(cert_b64)
    try:
        # Use one connection just for DDL + truncate
        admin_conn = make_connection(host, port, database, username, password, cert_path)
        print("Connected.\n")
        run_ddl_and_truncate(admin_conn)
        ibm_db.close(admin_conn)

        print(f"Loading {len(TABLES)} tables with {workers} parallel workers...\n")
        overall_start = time.time()

        with ThreadPoolExecutor(max_workers=workers) as executor:
            futures = {
                executor.submit(load_table, csv_file, schema, table,
                                host, port, database, username, password, cert_path): table
                for csv_file, schema, table in TABLES
            }
            for future in as_completed(futures):
                full_table, count, elapsed = future.result()
                tprint(f"  ✓ {full_table:<35s} {count:>7,} rows  ({elapsed:.1f}s)")

        total_elapsed = time.time() - overall_start
        print(f"\nAll done in {total_elapsed:.1f}s.")
    finally:
        os.unlink(cert_path)


if __name__ == "__main__":
    main()
