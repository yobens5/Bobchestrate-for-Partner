-- ============================================================================
-- SuperChampion DWH — Db2 on Cloud DDL
-- Run this FIRST in the Db2 console (Run SQL), then load the CSVs into these tables.
--
-- Translation notes (PostgreSQL -> Db2):
--   * text            -> VARCHAR(n)
--   * boolean         -> SMALLINT (0/1)   (CSVs export booleans as 0/1)
--   * serial/bigserial-> INTEGER/BIGINT   (key values come from the CSV)
--   * numeric(p,s)    -> DECIMAL(p,s)
--   * column "date"   -> renamed (Db2 keyword): dim_date.date->CAL_DATE,
--                        daily_store_sales.date->SALES_DATE
--   * No FOREIGN KEYS (so CSVs can be loaded in any order). PKs kept.
-- ============================================================================

CREATE SCHEMA DWH;
CREATE SCHEMA MART;

-- ---------------------------------------------------------------- DIMENSIONS
CREATE TABLE DWH.DIM_DATE (
    date_key       INTEGER     NOT NULL PRIMARY KEY,
    cal_date       DATE        NOT NULL,
    day            INTEGER     NOT NULL,
    month          INTEGER     NOT NULL,
    year           INTEGER     NOT NULL,
    quarter        INTEGER     NOT NULL,
    day_of_week    INTEGER     NOT NULL,
    iso_dow        INTEGER     NOT NULL,
    day_name       VARCHAR(16) NOT NULL,
    month_name     VARCHAR(16) NOT NULL,
    week_of_year   INTEGER     NOT NULL,
    is_weekend     SMALLINT    NOT NULL,
    is_holiday     SMALLINT    NOT NULL,
    holiday_name   VARCHAR(64),
    is_holiday_eve SMALLINT    NOT NULL
);

CREATE TABLE DWH.DIM_STORE (
    store_key       INTEGER      NOT NULL PRIMARY KEY,
    store_code      VARCHAR(16)  NOT NULL,
    store_name      VARCHAR(64)  NOT NULL,
    city            VARCHAR(48)  NOT NULL,
    district        VARCHAR(24)  NOT NULL,
    store_type      VARCHAR(16)  NOT NULL,
    size_sqm        INTEGER      NOT NULL,
    opening_date    DATE         NOT NULL,
    is_shabbat_open SMALLINT     NOT NULL,
    latitude        DECIMAL(9,6),
    longitude       DECIMAL(9,6),
    is_active       SMALLINT     NOT NULL
);

CREATE TABLE DWH.DIM_PRODUCT (
    product_key      INTEGER      NOT NULL PRIMARY KEY,
    sku              VARCHAR(16)  NOT NULL,
    product_name     VARCHAR(64)  NOT NULL,
    category         VARCHAR(32)  NOT NULL,
    subcategory      VARCHAR(32)  NOT NULL,
    brand            VARCHAR(48)  NOT NULL,
    unit_cost        DECIMAL(10,2) NOT NULL,
    unit_price       DECIMAL(10,2) NOT NULL,
    base_daily_units DECIMAL(8,2)  NOT NULL,
    is_kosher        SMALLINT     NOT NULL,
    supplier_name    VARCHAR(48)  NOT NULL
);

CREATE TABLE DWH.DIM_EMPLOYEE (
    employee_key    INTEGER      NOT NULL PRIMARY KEY,
    employee_code   VARCHAR(16)  NOT NULL,
    full_name       VARCHAR(64)  NOT NULL,
    store_key       INTEGER      NOT NULL,
    role            VARCHAR(24)  NOT NULL,
    employment_type VARCHAR(16)  NOT NULL,
    hire_date       DATE         NOT NULL,
    hourly_rate     DECIMAL(8,2) NOT NULL,
    is_active       SMALLINT     NOT NULL
);

-- --------------------------------------------------------------------- FACTS
CREATE TABLE DWH.FACT_SALES (
    sale_key         BIGINT       NOT NULL PRIMARY KEY,
    date_key         INTEGER      NOT NULL,
    store_key        INTEGER      NOT NULL,
    product_key      INTEGER      NOT NULL,
    units_sold       INTEGER      NOT NULL,
    gross_revenue    DECIMAL(12,2) NOT NULL,
    discount_amount  DECIMAL(12,2) NOT NULL,
    net_revenue      DECIMAL(12,2) NOT NULL,
    cost_amount      DECIMAL(12,2) NOT NULL,
    gross_margin     DECIMAL(12,2) NOT NULL,
    num_transactions INTEGER      NOT NULL
);

CREATE TABLE DWH.FACT_INVENTORY_SNAPSHOT (
    snapshot_key     BIGINT       NOT NULL PRIMARY KEY,
    date_key         INTEGER      NOT NULL,
    store_key        INTEGER      NOT NULL,
    product_key      INTEGER      NOT NULL,
    units_on_hand    INTEGER      NOT NULL,
    units_on_order   INTEGER      NOT NULL,
    reorder_point    INTEGER      NOT NULL,
    is_below_reorder SMALLINT     NOT NULL,
    stock_value      DECIMAL(12,2) NOT NULL,
    days_of_supply   DECIMAL(6,1) NOT NULL
);

CREATE TABLE DWH.FACT_EMPLOYEE_SHIFT (
    shift_key        BIGINT       NOT NULL PRIMARY KEY,
    date_key         INTEGER      NOT NULL,
    store_key        INTEGER      NOT NULL,
    employee_key     INTEGER      NOT NULL,
    shift_type       VARCHAR(12)  NOT NULL,
    scheduled_hours  DECIMAL(4,1) NOT NULL,
    actual_hours     DECIMAL(4,1) NOT NULL,
    labor_cost       DECIMAL(10,2) NOT NULL,
    is_overtime      SMALLINT     NOT NULL
);

-- --------------------------------------------------------------------- MARTS
CREATE TABLE MART.DAILY_STORE_SALES (
    sales_date       DATE         NOT NULL,
    date_key         INTEGER      NOT NULL,
    store_key        INTEGER      NOT NULL,
    store_name       VARCHAR(64)  NOT NULL,
    city             VARCHAR(48)  NOT NULL,
    district         VARCHAR(24)  NOT NULL,
    store_type       VARCHAR(16)  NOT NULL,
    units_sold       BIGINT       NOT NULL,
    gross_revenue    DECIMAL(14,2) NOT NULL,
    discount_amount  DECIMAL(14,2) NOT NULL,
    net_revenue      DECIMAL(14,2) NOT NULL,
    total_cost       DECIMAL(14,2) NOT NULL,
    gross_margin     DECIMAL(14,2) NOT NULL,
    margin_pct       DECIMAL(6,2),
    num_transactions BIGINT       NOT NULL,
    distinct_products INTEGER     NOT NULL,
    avg_basket_value DECIMAL(10,2),
    PRIMARY KEY (date_key, store_key)
);

CREATE TABLE MART.MONTHLY_STORE_PNL (
    year             INTEGER      NOT NULL,
    month            INTEGER      NOT NULL,
    month_name       VARCHAR(16)  NOT NULL,
    store_key        INTEGER      NOT NULL,
    store_name       VARCHAR(64)  NOT NULL,
    city             VARCHAR(48)  NOT NULL,
    district         VARCHAR(24)  NOT NULL,
    net_revenue      DECIMAL(14,2) NOT NULL,
    gross_margin     DECIMAL(14,2) NOT NULL,
    labor_cost       DECIMAL(14,2) NOT NULL,
    labor_pct_of_revenue DECIMAL(6,2),
    contribution     DECIMAL(14,2) NOT NULL,
    num_transactions BIGINT       NOT NULL,
    PRIMARY KEY (year, month, store_key)
);

CREATE TABLE MART.CATEGORY_MONTHLY_SALES (
    year         INTEGER      NOT NULL,
    month        INTEGER      NOT NULL,
    category     VARCHAR(32)  NOT NULL,
    units_sold   BIGINT       NOT NULL,
    net_revenue  DECIMAL(14,2) NOT NULL,
    gross_margin DECIMAL(14,2) NOT NULL,
    margin_pct   DECIMAL(6,2),
    PRIMARY KEY (year, month, category)
);

CREATE TABLE MART.STORE_LABOR_MONTHLY (
    year            INTEGER      NOT NULL,
    month           INTEGER      NOT NULL,
    store_key       INTEGER      NOT NULL,
    store_name      VARCHAR(64)  NOT NULL,
    district        VARCHAR(24)  NOT NULL,
    total_hours     DECIMAL(12,1) NOT NULL,
    overtime_hours  DECIMAL(12,1) NOT NULL,
    labor_cost      DECIMAL(14,2) NOT NULL,
    headcount       INTEGER      NOT NULL,
    avg_hourly_cost DECIMAL(8,2),
    PRIMARY KEY (year, month, store_key)
);

CREATE TABLE MART.INVENTORY_HEALTH_CURRENT (
    store_key          INTEGER      NOT NULL PRIMARY KEY,
    store_name         VARCHAR(64)  NOT NULL,
    district           VARCHAR(24)  NOT NULL,
    snapshot_date      DATE         NOT NULL,
    skus_stocked       INTEGER      NOT NULL,
    total_stock_value  DECIMAL(14,2) NOT NULL,
    skus_below_reorder INTEGER      NOT NULL,
    pct_below_reorder  DECIMAL(6,2),
    avg_days_of_supply DECIMAL(6,1)
);

CREATE TABLE MART.MONTHLY_CHAIN_KPI (
    year             INTEGER      NOT NULL,
    month            INTEGER      NOT NULL,
    month_name       VARCHAR(16)  NOT NULL,
    active_stores    INTEGER      NOT NULL,
    net_revenue      DECIMAL(16,2) NOT NULL,
    gross_margin     DECIMAL(16,2) NOT NULL,
    margin_pct       DECIMAL(6,2),
    labor_cost       DECIMAL(16,2) NOT NULL,
    contribution     DECIMAL(16,2) NOT NULL,
    num_transactions BIGINT       NOT NULL,
    avg_basket_value DECIMAL(10,2),
    PRIMARY KEY (year, month)
);
