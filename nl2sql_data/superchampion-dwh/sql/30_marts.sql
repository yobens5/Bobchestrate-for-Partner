-- ============================================================================
-- SuperChampion DWH — BI marts (pre-aggregated / "prémâché")
-- Built from the dwh.* facts. These are what BI tools/dashboards query directly.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- mart.daily_store_sales : one row per store per day
-- ----------------------------------------------------------------------------
TRUNCATE mart.daily_store_sales;
INSERT INTO mart.daily_store_sales
SELECT
    d.date, d.date_key, st.store_key, st.store_name, st.city, st.district, st.store_type,
    sum(f.units_sold),
    sum(f.gross_revenue),
    sum(f.discount_amount),
    sum(f.net_revenue),
    sum(f.cost_amount),
    sum(f.gross_margin),
    round(sum(f.gross_margin) / nullif(sum(f.net_revenue),0) * 100, 2),
    sum(f.num_transactions),
    count(DISTINCT f.product_key),
    round(sum(f.net_revenue) / nullif(sum(f.num_transactions),0), 2)
FROM dwh.fact_sales f
JOIN dwh.dim_date  d  USING (date_key)
JOIN dwh.dim_store st USING (store_key)
GROUP BY d.date, d.date_key, st.store_key, st.store_name, st.city, st.district, st.store_type;

-- ----------------------------------------------------------------------------
-- mart.monthly_store_pnl : revenue + labor + contribution per store per month
-- ----------------------------------------------------------------------------
TRUNCATE mart.monthly_store_pnl;
WITH sales AS (
    SELECT st.store_key, d.year, d.month,
           sum(f.net_revenue)      AS net_revenue,
           sum(f.gross_margin)     AS gross_margin,
           sum(f.num_transactions) AS num_transactions
    FROM dwh.fact_sales f
    JOIN dwh.dim_date  d  USING (date_key)
    JOIN dwh.dim_store st USING (store_key)
    GROUP BY st.store_key, d.year, d.month
),
labor AS (
    SELECT s.store_key, d.year, d.month,
           sum(s.labor_cost) AS labor_cost
    FROM dwh.fact_employee_shift s
    JOIN dwh.dim_date d USING (date_key)
    GROUP BY s.store_key, d.year, d.month
)
INSERT INTO mart.monthly_store_pnl
SELECT
    COALESCE(sa.year, la.year),
    COALESCE(sa.month, la.month),
    to_char(make_date(COALESCE(sa.year, la.year), COALESCE(sa.month, la.month), 1), 'Month'),
    st.store_key, st.store_name, st.city, st.district,
    COALESCE(sa.net_revenue, 0),
    COALESCE(sa.gross_margin, 0),
    COALESCE(la.labor_cost, 0),
    round(COALESCE(la.labor_cost,0) / nullif(sa.net_revenue,0) * 100, 2),
    COALESCE(sa.gross_margin,0) - COALESCE(la.labor_cost,0),
    COALESCE(sa.num_transactions, 0)
FROM sales sa
FULL JOIN labor la USING (store_key, year, month)
JOIN dwh.dim_store st ON st.store_key = COALESCE(sa.store_key, la.store_key);

-- ----------------------------------------------------------------------------
-- mart.category_monthly_sales : category performance per month
-- ----------------------------------------------------------------------------
TRUNCATE mart.category_monthly_sales;
INSERT INTO mart.category_monthly_sales
SELECT
    d.year, d.month, p.category,
    sum(f.units_sold),
    sum(f.net_revenue),
    sum(f.gross_margin),
    round(sum(f.gross_margin) / nullif(sum(f.net_revenue),0) * 100, 2)
FROM dwh.fact_sales f
JOIN dwh.dim_date    d USING (date_key)
JOIN dwh.dim_product p USING (product_key)
GROUP BY d.year, d.month, p.category;

-- ----------------------------------------------------------------------------
-- mart.store_labor_monthly : labor summary per store per month
-- ----------------------------------------------------------------------------
TRUNCATE mart.store_labor_monthly;
INSERT INTO mart.store_labor_monthly
SELECT
    d.year, d.month, st.store_key, st.store_name, st.district,
    round(sum(s.actual_hours), 1),
    round(sum(s.actual_hours) FILTER (WHERE s.is_overtime), 1),
    sum(s.labor_cost),
    count(DISTINCT s.employee_key),
    round(sum(s.labor_cost) / nullif(sum(s.actual_hours),0), 2)
FROM dwh.fact_employee_shift s
JOIN dwh.dim_date  d  USING (date_key)
JOIN dwh.dim_store st USING (store_key)
GROUP BY d.year, d.month, st.store_key, st.store_name, st.district;

-- ----------------------------------------------------------------------------
-- mart.inventory_health_current : latest weekly snapshot per store
-- ----------------------------------------------------------------------------
TRUNCATE mart.inventory_health_current;
WITH latest AS (
    SELECT store_key, max(date_key) AS date_key
    FROM dwh.fact_inventory_snapshot
    GROUP BY store_key
)
INSERT INTO mart.inventory_health_current
SELECT
    st.store_key, st.store_name, st.district,
    d.date,
    count(*),
    sum(f.stock_value),
    count(*) FILTER (WHERE f.is_below_reorder),
    round(count(*) FILTER (WHERE f.is_below_reorder)::numeric / nullif(count(*),0) * 100, 2),
    round(avg(f.days_of_supply), 1)
FROM dwh.fact_inventory_snapshot f
JOIN latest l ON l.store_key = f.store_key AND l.date_key = f.date_key
JOIN dwh.dim_store st ON st.store_key = f.store_key
JOIN dwh.dim_date  d  ON d.date_key  = f.date_key
GROUP BY st.store_key, st.store_name, st.district, d.date;

-- ----------------------------------------------------------------------------
-- mart.monthly_chain_kpi : chain-wide KPIs per month
-- ----------------------------------------------------------------------------
TRUNCATE mart.monthly_chain_kpi;
WITH sales AS (
    SELECT d.year, d.month,
           sum(f.net_revenue) net_revenue, sum(f.gross_margin) gross_margin,
           sum(f.num_transactions) num_transactions,
           count(DISTINCT f.store_key) active_stores
    FROM dwh.fact_sales f JOIN dwh.dim_date d USING (date_key)
    GROUP BY d.year, d.month
),
labor AS (
    SELECT d.year, d.month, sum(s.labor_cost) labor_cost
    FROM dwh.fact_employee_shift s JOIN dwh.dim_date d USING (date_key)
    GROUP BY d.year, d.month
)
INSERT INTO mart.monthly_chain_kpi
SELECT
    sa.year, sa.month,
    to_char(make_date(sa.year, sa.month, 1), 'Month'),
    sa.active_stores,
    sa.net_revenue,
    sa.gross_margin,
    round(sa.gross_margin / nullif(sa.net_revenue,0) * 100, 2),
    COALESCE(la.labor_cost,0),
    sa.gross_margin - COALESCE(la.labor_cost,0),
    sa.num_transactions,
    round(sa.net_revenue / nullif(sa.num_transactions,0), 2)
FROM sales sa
LEFT JOIN labor la USING (year, month);

ANALYZE mart.daily_store_sales;
ANALYZE mart.monthly_store_pnl;
ANALYZE mart.category_monthly_sales;
ANALYZE mart.store_labor_monthly;
ANALYZE mart.inventory_health_current;
ANALYZE mart.monthly_chain_kpi;
