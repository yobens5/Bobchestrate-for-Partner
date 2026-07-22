-- ============================================================================
-- SuperChampion DWH — Fact data (generated set-based)
-- Israeli retail dynamics baked in:
--   * Saturday (Shabbat): only is_shabbat_open stores trade, at reduced volume
--   * Friday: pre-Shabbat shopping peak (x1.7)
--   * Holidays: stores closed; holiday eve = big peak (x1.9)
--   * Store type scales volume: Hypermarket > Supermarket > Express
-- ============================================================================

-- ----------------------------------------------------------------------------
-- fact_sales : store × product × day (sparse). ~2 years.
-- ----------------------------------------------------------------------------
INSERT INTO dwh.fact_sales
    (date_key, store_key, product_key, units_sold, gross_revenue,
     discount_amount, net_revenue, cost_amount, gross_margin, num_transactions)
SELECT
    date_key, store_key, product_key, units,
    round(units * unit_price, 2)                                  AS gross_revenue,
    round(units * unit_price * disc, 2)                           AS discount_amount,
    round(units * unit_price * (1 - disc), 2)                     AS net_revenue,
    round(units * unit_cost, 2)                                   AS cost_amount,
    round(units * unit_price * (1 - disc) - units * unit_cost, 2) AS gross_margin,
    greatest(1, ceil(units / (2 + random()*4)))::int             AS num_transactions
FROM (
    SELECT
        d.date_key, st.store_key, p.product_key, p.unit_price, p.unit_cost,
        (random() * 0.12)::numeric AS disc,
        round(
            p.base_daily_units
            * CASE st.store_type
                  WHEN 'Hypermarket' THEN 2.3
                  WHEN 'Supermarket' THEN 1.0
                  ELSE 0.45
              END
            * CASE
                  WHEN d.is_holiday          THEN 0
                  WHEN d.is_holiday_eve      THEN 1.9
                  WHEN d.day_of_week = 6     THEN CASE WHEN st.is_shabbat_open THEN 0.45 ELSE 0 END
                  WHEN d.day_of_week = 5     THEN 1.7
                  WHEN d.day_of_week = 0     THEN 1.15
                  ELSE 1.0
              END
            * (0.6 + random()*0.8)
        )::int AS units
    FROM dwh.dim_date d
    CROSS JOIN dwh.dim_store st
    CROSS JOIN dwh.dim_product p
    WHERE d.date >= st.opening_date
      AND random() < 0.40           -- sample to keep the fact sparse/realistic
) s
WHERE units >= 1;

-- ----------------------------------------------------------------------------
-- fact_inventory_snapshot : store × product × week (Sunday = start of Israeli week)
-- ----------------------------------------------------------------------------
INSERT INTO dwh.fact_inventory_snapshot
    (date_key, store_key, product_key, units_on_hand, units_on_order,
     reorder_point, is_below_reorder, stock_value, days_of_supply)
SELECT
    date_key, store_key, product_key, on_hand,
    CASE WHEN on_hand < reorder THEN reorder * 2 ELSE 0 END   AS units_on_order,
    reorder,
    on_hand < reorder                                        AS is_below_reorder,
    round(on_hand * unit_cost, 2)                            AS stock_value,
    round(on_hand / nullif(daily, 0), 1)                     AS days_of_supply
FROM (
    SELECT
        d.date_key, st.store_key, p.product_key, p.unit_cost,
        (p.base_daily_units * CASE st.store_type
            WHEN 'Hypermarket' THEN 2.3 WHEN 'Supermarket' THEN 1.0 ELSE 0.45 END) AS daily,
        round(p.base_daily_units * CASE st.store_type
            WHEN 'Hypermarket' THEN 2.3 WHEN 'Supermarket' THEN 1.0 ELSE 0.45 END
            * (0.5 + random()*8))::int AS on_hand,
        round(p.base_daily_units * CASE st.store_type
            WHEN 'Hypermarket' THEN 2.3 WHEN 'Supermarket' THEN 1.0 ELSE 0.45 END
            * 2)::int AS reorder
    FROM dwh.dim_date d
    CROSS JOIN dwh.dim_store st
    CROSS JOIN dwh.dim_product p
    WHERE d.day_of_week = 0           -- Sunday snapshots
      AND d.date >= st.opening_date
      AND random() < 0.92
) q;

-- ----------------------------------------------------------------------------
-- fact_employee_shift : employee × working day (Sun-Fri, no holidays)
-- ----------------------------------------------------------------------------
INSERT INTO dwh.fact_employee_shift
    (date_key, store_key, employee_key, shift_type, scheduled_hours,
     actual_hours, labor_cost, is_overtime)
SELECT
    d.date_key, e.store_key, e.employee_key, sh.shift_type,
    sc.sched, ac.act,
    round(ac.act * e.hourly_rate, 2)        AS labor_cost,
    ac.act > sc.sched + 0.25                 AS is_overtime
FROM dwh.dim_employee e
JOIN dwh.dim_date d
       ON d.day_of_week IN (0,1,2,3,4,5)     -- Sun..Fri
      AND d.is_holiday = false
      AND d.date >= e.hire_date
CROSS JOIN LATERAL (
    SELECT (ARRAY['Morning','Afternoon','Night','Morning','Afternoon'])[1 + floor(random()*5)] AS shift_type
) sh
CROSS JOIN LATERAL (
    SELECT CASE
               WHEN d.day_of_week = 5            THEN 5.0    -- Friday short day
               WHEN e.employment_type = 'Part-time' THEN 6.0
               WHEN e.employment_type = 'Student'   THEN 6.0
               ELSE 8.5
           END AS sched
) sc
CROSS JOIN LATERAL (
    SELECT round((sc.sched + (random() - 0.35) * 1.6)::numeric, 1) AS act
) ac
WHERE NOT (d.day_of_week = 5 AND random() < 0.5)   -- fewer staff work Fridays
  AND random() < CASE e.employment_type
                     WHEN 'Full-time' THEN 0.82
                     WHEN 'Part-time' THEN 0.50
                     ELSE 0.38
                 END;

-- ----------------------------------------------------------------------------
-- Indexes on facts (created after bulk load)
-- ----------------------------------------------------------------------------
CREATE INDEX idx_fact_sales_date    ON dwh.fact_sales(date_key);
CREATE INDEX idx_fact_sales_store   ON dwh.fact_sales(store_key);
CREATE INDEX idx_fact_sales_product ON dwh.fact_sales(product_key);
CREATE INDEX idx_fact_inv_date      ON dwh.fact_inventory_snapshot(date_key);
CREATE INDEX idx_fact_inv_store     ON dwh.fact_inventory_snapshot(store_key);
CREATE INDEX idx_fact_shift_date    ON dwh.fact_employee_shift(date_key);
CREATE INDEX idx_fact_shift_store   ON dwh.fact_employee_shift(store_key);
CREATE INDEX idx_fact_shift_emp     ON dwh.fact_employee_shift(employee_key);

ANALYZE dwh.fact_sales;
ANALYZE dwh.fact_inventory_snapshot;
ANALYZE dwh.fact_employee_shift;
