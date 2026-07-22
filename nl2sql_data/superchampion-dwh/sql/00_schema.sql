-- ============================================================================
-- SuperChampion DWH — Schema (DDL)
-- Retail chain data warehouse. All money in ILS (₪). Context: Israel.
-- Dimensional model: schema `dwh` (dimensions + facts), schema `mart` (pre-aggregated BI tables).
-- Re-runnable: drops and recreates both schemas.
-- ============================================================================

DROP SCHEMA IF EXISTS mart CASCADE;
DROP SCHEMA IF EXISTS dwh  CASCADE;
CREATE SCHEMA dwh;
CREATE SCHEMA mart;

-- Make both schemas visible by default on new connections to this database.
ALTER DATABASE superchampion SET search_path = mart, dwh, public;

-- ----------------------------------------------------------------------------
-- DIMENSIONS
-- ----------------------------------------------------------------------------

CREATE TABLE dwh.dim_date (
    date_key        integer PRIMARY KEY,        -- YYYYMMDD
    date            date    NOT NULL UNIQUE,
    day             integer NOT NULL,
    month           integer NOT NULL,
    year            integer NOT NULL,
    quarter         integer NOT NULL,
    day_of_week     integer NOT NULL,           -- 0=Sun .. 6=Sat (Postgres dow)
    iso_dow         integer NOT NULL,           -- 1=Mon .. 7=Sun
    day_name        text    NOT NULL,
    month_name      text    NOT NULL,
    week_of_year    integer NOT NULL,
    is_weekend      boolean NOT NULL,           -- Israeli weekend = Fri + Sat
    is_holiday      boolean NOT NULL,
    holiday_name    text,
    is_holiday_eve  boolean NOT NULL            -- day before a holiday (pre-holiday shopping peak)
);

CREATE TABLE dwh.dim_store (
    store_key        serial PRIMARY KEY,
    store_code       text   NOT NULL UNIQUE,
    store_name       text   NOT NULL,
    city             text   NOT NULL,
    district         text   NOT NULL,           -- one of Israel's administrative districts
    store_type       text   NOT NULL,           -- Hypermarket | Supermarket | Express
    size_sqm         integer NOT NULL,
    opening_date     date   NOT NULL,
    is_shabbat_open  boolean NOT NULL,          -- open on Saturday (Shabbat)
    latitude         numeric(9,6),
    longitude        numeric(9,6),
    is_active        boolean NOT NULL DEFAULT true
);

CREATE TABLE dwh.dim_product (
    product_key      serial PRIMARY KEY,
    sku              text   NOT NULL UNIQUE,
    product_name     text   NOT NULL,
    category         text   NOT NULL,
    subcategory      text   NOT NULL,
    brand            text   NOT NULL,
    unit_cost        numeric(10,2) NOT NULL,    -- ILS
    unit_price       numeric(10,2) NOT NULL,    -- ILS retail/list price
    base_daily_units numeric(8,2)  NOT NULL,    -- popularity / velocity seed
    is_kosher        boolean NOT NULL,
    supplier_name    text   NOT NULL
);

CREATE TABLE dwh.dim_employee (
    employee_key     serial PRIMARY KEY,
    employee_code    text   NOT NULL UNIQUE,
    full_name        text   NOT NULL,
    store_key        integer NOT NULL REFERENCES dwh.dim_store(store_key),
    role             text   NOT NULL,
    employment_type  text   NOT NULL,           -- Full-time | Part-time | Student
    hire_date        date   NOT NULL,
    hourly_rate      numeric(8,2) NOT NULL,     -- ILS / hour
    is_active        boolean NOT NULL DEFAULT true
);

-- ----------------------------------------------------------------------------
-- FACTS
-- ----------------------------------------------------------------------------

-- Grain: one row per store × product × day with sales.
CREATE TABLE dwh.fact_sales (
    sale_key         bigserial PRIMARY KEY,
    date_key         integer NOT NULL REFERENCES dwh.dim_date(date_key),
    store_key        integer NOT NULL REFERENCES dwh.dim_store(store_key),
    product_key      integer NOT NULL REFERENCES dwh.dim_product(product_key),
    units_sold       integer NOT NULL,
    gross_revenue    numeric(12,2) NOT NULL,    -- units * unit_price
    discount_amount  numeric(12,2) NOT NULL,
    net_revenue      numeric(12,2) NOT NULL,    -- gross - discount
    cost_amount      numeric(12,2) NOT NULL,    -- units * unit_cost
    gross_margin     numeric(12,2) NOT NULL,    -- net_revenue - cost_amount
    num_transactions integer NOT NULL
);

-- Grain: one row per store × product × week (Sunday snapshot).
CREATE TABLE dwh.fact_inventory_snapshot (
    snapshot_key     bigserial PRIMARY KEY,
    date_key         integer NOT NULL REFERENCES dwh.dim_date(date_key),
    store_key        integer NOT NULL REFERENCES dwh.dim_store(store_key),
    product_key      integer NOT NULL REFERENCES dwh.dim_product(product_key),
    units_on_hand    integer NOT NULL,
    units_on_order   integer NOT NULL,
    reorder_point    integer NOT NULL,
    is_below_reorder boolean NOT NULL,
    stock_value      numeric(12,2) NOT NULL,    -- units_on_hand * unit_cost
    days_of_supply   numeric(6,1)  NOT NULL
);

-- Grain: one row per employee shift (employee × day).
CREATE TABLE dwh.fact_employee_shift (
    shift_key        bigserial PRIMARY KEY,
    date_key         integer NOT NULL REFERENCES dwh.dim_date(date_key),
    store_key        integer NOT NULL REFERENCES dwh.dim_store(store_key),
    employee_key     integer NOT NULL REFERENCES dwh.dim_employee(employee_key),
    shift_type       text    NOT NULL,          -- Morning | Afternoon | Night
    scheduled_hours  numeric(4,1) NOT NULL,
    actual_hours     numeric(4,1) NOT NULL,
    labor_cost       numeric(10,2) NOT NULL,    -- actual_hours * hourly_rate
    is_overtime      boolean NOT NULL
);

-- ----------------------------------------------------------------------------
-- MART (pre-aggregated BI tables — "prémâché")
-- ----------------------------------------------------------------------------

CREATE TABLE mart.daily_store_sales (
    date             date    NOT NULL,
    date_key         integer NOT NULL,
    store_key        integer NOT NULL,
    store_name       text    NOT NULL,
    city             text    NOT NULL,
    district         text    NOT NULL,
    store_type       text    NOT NULL,
    units_sold       bigint  NOT NULL,
    gross_revenue    numeric(14,2) NOT NULL,
    discount_amount  numeric(14,2) NOT NULL,
    net_revenue      numeric(14,2) NOT NULL,
    total_cost       numeric(14,2) NOT NULL,
    gross_margin     numeric(14,2) NOT NULL,
    margin_pct       numeric(6,2),
    num_transactions bigint  NOT NULL,
    distinct_products integer NOT NULL,
    avg_basket_value numeric(10,2),
    PRIMARY KEY (date_key, store_key)
);

CREATE TABLE mart.monthly_store_pnl (
    year             integer NOT NULL,
    month            integer NOT NULL,
    month_name       text    NOT NULL,
    store_key        integer NOT NULL,
    store_name       text    NOT NULL,
    city             text    NOT NULL,
    district         text    NOT NULL,
    net_revenue      numeric(14,2) NOT NULL,
    gross_margin     numeric(14,2) NOT NULL,
    labor_cost       numeric(14,2) NOT NULL,
    labor_pct_of_revenue numeric(6,2),
    contribution     numeric(14,2) NOT NULL,    -- gross_margin - labor_cost
    num_transactions bigint  NOT NULL,
    PRIMARY KEY (year, month, store_key)
);

CREATE TABLE mart.category_monthly_sales (
    year             integer NOT NULL,
    month            integer NOT NULL,
    category         text    NOT NULL,
    units_sold       bigint  NOT NULL,
    net_revenue      numeric(14,2) NOT NULL,
    gross_margin     numeric(14,2) NOT NULL,
    margin_pct       numeric(6,2),
    PRIMARY KEY (year, month, category)
);

CREATE TABLE mart.store_labor_monthly (
    year             integer NOT NULL,
    month            integer NOT NULL,
    store_key        integer NOT NULL,
    store_name       text    NOT NULL,
    district         text    NOT NULL,
    total_hours      numeric(12,1) NOT NULL,
    overtime_hours   numeric(12,1) NOT NULL,
    labor_cost       numeric(14,2) NOT NULL,
    headcount        integer NOT NULL,
    avg_hourly_cost  numeric(8,2),
    PRIMARY KEY (year, month, store_key)
);

CREATE TABLE mart.inventory_health_current (
    store_key        integer PRIMARY KEY,
    store_name       text    NOT NULL,
    district         text    NOT NULL,
    snapshot_date    date    NOT NULL,
    skus_stocked     integer NOT NULL,
    total_stock_value numeric(14,2) NOT NULL,
    skus_below_reorder integer NOT NULL,
    pct_below_reorder  numeric(6,2),
    avg_days_of_supply numeric(6,1)
);

CREATE TABLE mart.monthly_chain_kpi (
    year             integer NOT NULL,
    month            integer NOT NULL,
    month_name       text    NOT NULL,
    active_stores    integer NOT NULL,
    net_revenue      numeric(16,2) NOT NULL,
    gross_margin     numeric(16,2) NOT NULL,
    margin_pct       numeric(6,2),
    labor_cost       numeric(16,2) NOT NULL,
    contribution     numeric(16,2) NOT NULL,
    num_transactions bigint  NOT NULL,
    avg_basket_value numeric(10,2),
    PRIMARY KEY (year, month)
);
