-- ============================================================================
-- SuperChampion DWH — sanity checks & sample BI queries
-- ============================================================================
\echo '==================== ROW COUNTS ===================='
SELECT 'dim_date'                AS table, count(*) FROM dwh.dim_date
UNION ALL SELECT 'dim_store',                count(*) FROM dwh.dim_store
UNION ALL SELECT 'dim_product',              count(*) FROM dwh.dim_product
UNION ALL SELECT 'dim_employee',             count(*) FROM dwh.dim_employee
UNION ALL SELECT 'fact_sales',               count(*) FROM dwh.fact_sales
UNION ALL SELECT 'fact_inventory_snapshot',  count(*) FROM dwh.fact_inventory_snapshot
UNION ALL SELECT 'fact_employee_shift',      count(*) FROM dwh.fact_employee_shift
UNION ALL SELECT 'mart.daily_store_sales',   count(*) FROM mart.daily_store_sales
UNION ALL SELECT 'mart.monthly_store_pnl',   count(*) FROM mart.monthly_store_pnl
UNION ALL SELECT 'mart.category_monthly_sales', count(*) FROM mart.category_monthly_sales
UNION ALL SELECT 'mart.store_labor_monthly', count(*) FROM mart.store_labor_monthly
UNION ALL SELECT 'mart.inventory_health_current', count(*) FROM mart.inventory_health_current
UNION ALL SELECT 'mart.monthly_chain_kpi',   count(*) FROM mart.monthly_chain_kpi
ORDER BY 1;

\echo ''
\echo '==================== Top 8 stores by 2025 revenue (ILS) ===================='
SELECT store_name, district,
       to_char(sum(net_revenue),'FM999,999,999') AS net_revenue_ils,
       round(avg(margin_pct),1) AS avg_margin_pct
FROM mart.daily_store_sales
WHERE extract(year from date) = 2025
GROUP BY store_name, district
ORDER BY sum(net_revenue) DESC
LIMIT 8;

\echo ''
\echo '==================== Revenue by day-of-week (Israeli week: Fri peaks, Sat low) ===================='
SELECT d.day_name,
       to_char(sum(s.net_revenue),'FM999,999,999') AS net_revenue_ils
FROM mart.daily_store_sales s
JOIN dwh.dim_date d ON d.date = s.date
GROUP BY d.day_name, d.iso_dow
ORDER BY d.iso_dow;

\echo ''
\echo '==================== Chain monthly KPIs (first 6 months) ===================='
SELECT year, trim(month_name) AS month, active_stores,
       to_char(net_revenue,'FM999,999,999') AS net_revenue_ils,
       margin_pct,
       to_char(labor_cost,'FM999,999,999')  AS labor_cost_ils,
       avg_basket_value
FROM mart.monthly_chain_kpi
ORDER BY year, month
LIMIT 6;

\echo ''
\echo '==================== Inventory health (stores most below reorder) ===================='
SELECT store_name, district, snapshot_date, skus_stocked,
       to_char(total_stock_value,'FM999,999,999') AS stock_value_ils,
       skus_below_reorder, pct_below_reorder
FROM mart.inventory_health_current
ORDER BY pct_below_reorder DESC
LIMIT 8;
