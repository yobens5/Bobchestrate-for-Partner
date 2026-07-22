# SuperChampion DWH

A self-contained **PostgreSQL data warehouse** for **SuperChampion**, a fictional retail
supermarket chain operating across **Israel**. This is a *dimensional / BI* model
(star schema + pre-aggregated marts) — **not** an ERP/OLTP schema. The fact and mart
tables are "pre-chewed" (prémâchés) so a BI tool can query them directly.

All monetary values are in **ILS (₪)**. Data spans **2024-01-01 → 2025-12-31**.

## What's modeled

Israeli retail realities are baked into the generated data:
- **Shabbat**: only stores flagged `is_shabbat_open` (Tel Aviv, Haifa, Eilat, Tiberias) trade on Saturday, at reduced volume; others are closed.
- **Friday** is the pre-Shabbat shopping peak (~1.7×).
- **Holidays** (Pesach, Rosh Hashana, Yom Kippur, …): stores closed; the **eve** before a holiday is a big peak (~1.9×).
- **Store format** scales volume: Hypermarket > Supermarket > Express.
- Weekend = **Friday + Saturday** (Israeli week starts Sunday).

## Schema layout

### `dwh` — dimensions + facts (star schema)
| Table | Grain | Notes |
|---|---|---|
| `dim_date` | 1 day | Israeli weekend & holiday flags, holiday eve |
| `dim_store` | 1 store | 24 stores, 6 districts, type, size, Shabbat-open, lat/lon |
| `dim_product` | 1 SKU | ~60 SKUs, Israeli brands, kosher flag, cost/price |
| `dim_employee` | 1 employee | role, employment type, hourly rate (ILS) |
| `fact_sales` | store × product × day | units, revenue, discount, cost, margin |
| `fact_inventory_snapshot` | store × product × week | on-hand, reorder, stock value, days of supply |
| `fact_employee_shift` | employee × day | shift type, hours, labor cost, overtime |

### `mart` — pre-aggregated BI tables (query these for dashboards)
| Table | Grain |
|---|---|
| `daily_store_sales` | store × day — revenue, margin, transactions, avg basket |
| `monthly_store_pnl` | store × month — revenue, margin, labor, **contribution** |
| `category_monthly_sales` | category × month |
| `store_labor_monthly` | store × month — hours, overtime, headcount |
| `inventory_health_current` | store — latest stock value & % below reorder |
| `monthly_chain_kpi` | month — chain-wide KPIs |

## Run it

Requires the local Homebrew PostgreSQL 17 server (already running on `localhost:5432`).

```bash
cd superchampion-dwh
./scripts/setup.sh        # creates the DB + loads schema, dimensions, facts, marts, then verifies
```

Other helpers:
```bash
./scripts/connect.sh      # open a psql shell on the warehouse
./scripts/reset.sh        # drop the DB and rebuild from scratch
```

## Connect from a BI tool

```
Host: localhost   Port: 5432   Database: superchampion   User: yohanbensoussan   (no password — local trust)
postgresql://yohanbensoussan@localhost:5432/superchampion
```
`search_path` defaults to `mart, dwh, public`, so you can write `SELECT * FROM daily_store_sales` directly.

## Sample BI queries

```sql
-- Top stores by 2025 revenue
SELECT store_name, district, sum(net_revenue) AS revenue_ils
FROM daily_store_sales WHERE extract(year from date)=2025
GROUP BY 1,2 ORDER BY 3 DESC LIMIT 10;

-- Friday-peak / Saturday-low pattern
SELECT d.day_name, sum(s.net_revenue) revenue_ils
FROM daily_store_sales s JOIN dwh.dim_date d ON d.date=s.date
GROUP BY d.day_name, d.iso_dow ORDER BY d.iso_dow;

-- Labor cost as % of revenue, per store, latest month
SELECT store_name, net_revenue, labor_cost, labor_pct_of_revenue, contribution
FROM monthly_store_pnl WHERE year=2025 AND month=12 ORDER BY contribution DESC;

-- Category margins
SELECT category, sum(net_revenue) revenue_ils, round(avg(margin_pct),1) margin_pct
FROM category_monthly_sales GROUP BY 1 ORDER BY 2 DESC;
```
