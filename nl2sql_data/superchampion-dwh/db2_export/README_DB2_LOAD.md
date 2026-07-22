# Load SuperChampion into Db2 on Cloud (web console)

No credentials needed here — you do the load in the Db2 console. Two steps:
**(1)** create the tables with the DDL, **(2)** upload each CSV into its table.

## 0. Open the Db2 console
IBM Cloud → **Resource list** → **Databases** → your **Db2** instance → **Open Console**
(button may be labelled *Go to UI* / *Manage → Open Console*).

## 1. Create the schemas + tables
In the console: **SQL** (the "Run SQL" editor) → paste the entire contents of
[`ddl/superchampion_db2_ddl.sql`](ddl/superchampion_db2_ddl.sql) → **Run all**.

This creates schemas **DWH** and **MART** and 13 empty tables. (No foreign keys, so CSVs
can be loaded in any order. Db2 upper-cases names — tables are `DWH.*` / `MART.*`.)

## 2. Load the CSVs
In the console: **Data → Load Data** (left nav). For **each** file in `csv/`:

1. **Source** → *My computer* → drag the CSV in.
2. **Target** → pick the **Schema** (`DWH` or `MART`) → pick the **table** with the matching name.
3. **File options** → tick **"The first row of the file contains column names"** (header),
   separator **comma `,`**, code page **UTF-8**. Leave the empty-string = NULL default on.
4. Review the column mapping (auto-matches by header) → **Next** → **Begin Load**.
5. Repeat for the next file.

> 💡 **Want to move fast?** The 6 `mart.*` tables are the pre-aggregated BI tables your
> agent/dashboards should query. Load those first; the 3 big `dwh.fact_*` files are the
> row-level detail and can come later.

### File → table → rows
| CSV file | Db2 table | Rows |
|---|---|--:|
| `csv/dwh.dim_date.csv` | `DWH.DIM_DATE` | 731 |
| `csv/dwh.dim_store.csv` | `DWH.DIM_STORE` | 24 |
| `csv/dwh.dim_product.csv` | `DWH.DIM_PRODUCT` | 67 |
| `csv/dwh.dim_employee.csv` | `DWH.DIM_EMPLOYEE` | 372 |
| `csv/dwh.fact_sales.csv` | `DWH.FACT_SALES` | 407,980 |
| `csv/dwh.fact_inventory_snapshot.csv` | `DWH.FACT_INVENTORY_SNAPSHOT` | 153,860 |
| `csv/dwh.fact_employee_shift.csv` | `DWH.FACT_EMPLOYEE_SHIFT` | 125,286 |
| `csv/mart.daily_store_sales.csv` | `MART.DAILY_STORE_SALES` | 15,216 |
| `csv/mart.monthly_store_pnl.csv` | `MART.MONTHLY_STORE_PNL` | 576 |
| `csv/mart.category_monthly_sales.csv` | `MART.CATEGORY_MONTHLY_SALES` | 264 |
| `csv/mart.store_labor_monthly.csv` | `MART.STORE_LABOR_MONTHLY` | 576 |
| `csv/mart.inventory_health_current.csv` | `MART.INVENTORY_HEALTH_CURRENT` | 24 |
| `csv/mart.monthly_chain_kpi.csv` | `MART.MONTHLY_CHAIN_KPI` | 24 |

> `fact_sales.csv` is ~24 MB. Browser upload handles it but takes a couple of minutes.
> If it ever times out, load it from **Cloud Object Storage** instead (ask me to repackage for COS).

## 3. Verify after loading
Paste into the console SQL editor:
```sql
SELECT COUNT(*) FROM MART.DAILY_STORE_SALES;          -- expect 15216
SELECT COUNT(*) FROM DWH.FACT_SALES;                  -- expect 407980

-- Friday peak / Saturday low (Israeli week)
SELECT d.day_name, SUM(s.net_revenue) AS revenue_ils
FROM MART.DAILY_STORE_SALES s JOIN DWH.DIM_DATE d ON d.cal_date = s.sales_date
GROUP BY d.day_name, d.iso_dow ORDER BY d.iso_dow;
```

## Notes / gotchas
- **Booleans** are stored as **SMALLINT 0/1** (Db2-friendly): `is_weekend`, `is_holiday`, `is_holiday_eve`, `is_shabbat_open`, `is_active`, `is_kosher`, `is_below_reorder`, `is_overtime`.
- Two columns were renamed to avoid the Db2 `DATE` keyword: `DIM_DATE.cal_date` and `DAILY_STORE_SALES.sales_date`.
- Point the **data-agent-builder** at the **`MART`** schema (uppercase) — those are the query-ready tables.
- To regenerate the CSVs after changing the local data: `./scripts/export_for_db2.sh`.
