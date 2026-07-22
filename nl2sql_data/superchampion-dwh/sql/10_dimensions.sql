-- ============================================================================
-- SuperChampion DWH — Dimension data
-- ============================================================================

-- ----------------------------------------------------------------------------
-- dim_date : 2024-01-01 .. 2025-12-31, Israeli calendar (weekend = Fri+Sat)
-- Holiday dates are approximate well-known dates, for demo/BI purposes.
-- ----------------------------------------------------------------------------
WITH days AS (
    SELECT g::date AS date
    FROM generate_series('2024-01-01'::date, '2025-12-31'::date, '1 day') g
),
hol AS (
    SELECT * FROM (VALUES
        ('2024-03-24'::date,'Purim'),
        ('2024-04-23','Pesach (1st day)'),
        ('2024-04-29','Pesach (7th day)'),
        ('2024-05-14','Independence Day'),
        ('2024-06-12','Shavuot'),
        ('2024-10-03','Rosh Hashana (1)'),
        ('2024-10-04','Rosh Hashana (2)'),
        ('2024-10-12','Yom Kippur'),
        ('2024-10-17','Sukkot (1st day)'),
        ('2024-10-24','Simchat Torah'),
        ('2024-12-26','Hanukkah'),
        ('2025-03-14','Purim'),
        ('2025-04-13','Pesach (1st day)'),
        ('2025-04-19','Pesach (7th day)'),
        ('2025-05-01','Independence Day'),
        ('2025-06-02','Shavuot'),
        ('2025-09-23','Rosh Hashana (1)'),
        ('2025-09-24','Rosh Hashana (2)'),
        ('2025-10-02','Yom Kippur'),
        ('2025-10-07','Sukkot (1st day)'),
        ('2025-10-14','Simchat Torah'),
        ('2025-12-15','Hanukkah')
    ) v(date, name)
)
INSERT INTO dwh.dim_date
    (date_key, date, day, month, year, quarter, day_of_week, iso_dow,
     day_name, month_name, week_of_year, is_weekend, is_holiday, holiday_name, is_holiday_eve)
SELECT
    to_char(d.date,'YYYYMMDD')::int,
    d.date,
    extract(day     from d.date)::int,
    extract(month   from d.date)::int,
    extract(year    from d.date)::int,
    extract(quarter from d.date)::int,
    extract(dow     from d.date)::int,
    extract(isodow  from d.date)::int,
    trim(to_char(d.date,'Day')),
    trim(to_char(d.date,'Month')),
    extract(week    from d.date)::int,
    extract(dow from d.date) IN (5,6),
    h.name IS NOT NULL,
    h.name,
    EXISTS (SELECT 1 FROM hol h2 WHERE h2.date = d.date + 1)
FROM days d
LEFT JOIN hol h ON h.date = d.date;

-- ----------------------------------------------------------------------------
-- dim_store : 24 SuperChampion stores across Israel's districts
-- ----------------------------------------------------------------------------
INSERT INTO dwh.dim_store
    (store_code, store_name, city, district, store_type, size_sqm, opening_date, is_shabbat_open, latitude, longitude)
VALUES
    ('SC-TLV-01','SuperChampion Dizengoff',     'Tel Aviv',        'Tel Aviv',  'Express',     420,  '2019-05-12', true,  32.080500, 34.773900),
    ('SC-TLV-02','SuperChampion Ramat Aviv',    'Tel Aviv',        'Tel Aviv',  'Supermarket', 1650, '2017-09-03', true,  32.113900, 34.804700),
    ('SC-RG-01', 'SuperChampion Ayalon',        'Ramat Gan',       'Tel Aviv',  'Hypermarket', 6200, '2015-11-20', false, 32.073200, 34.824500),
    ('SC-GIV-01','SuperChampion Givatayim',     'Givatayim',       'Tel Aviv',  'Supermarket', 1480, '2018-02-14', false, 32.072000, 34.812000),
    ('SC-HOL-01','SuperChampion Holon',         'Holon',           'Tel Aviv',  'Supermarket', 1720, '2016-07-08', false, 32.015800, 34.779200),
    ('SC-BY-01', 'SuperChampion Bat Yam',       'Bat Yam',         'Tel Aviv',  'Supermarket', 1390, '2019-12-01', false, 32.023000, 34.750300),
    ('SC-JM-01', 'SuperChampion Malha',         'Jerusalem',       'Jerusalem', 'Hypermarket', 5800, '2014-03-17', false, 31.749900, 35.187700),
    ('SC-JM-02', 'SuperChampion Talpiot',       'Jerusalem',       'Jerusalem', 'Supermarket', 1600, '2016-10-05', false, 31.751500, 35.219400),
    ('SC-JM-03', 'SuperChampion Givat Shaul',   'Jerusalem',       'Jerusalem', 'Supermarket', 1510, '2018-06-22', false, 31.793800, 35.184600),
    ('SC-HFA-01','SuperChampion Grand Canyon',  'Haifa',           'Haifa',     'Hypermarket', 6000, '2015-04-30', true,  32.794000, 34.989300),
    ('SC-HFA-02','SuperChampion Hadar',         'Haifa',           'Haifa',     'Supermarket', 1440, '2017-01-19', true,  32.811000, 34.998700),
    ('SC-KBI-01','SuperChampion Krayot',        'Kiryat Bialik',   'Haifa',     'Supermarket', 1680, '2019-08-11', false, 32.836300, 35.086900),
    ('SC-NTY-01','SuperChampion Ir Yamim',      'Netanya',         'Central',   'Supermarket', 1750, '2018-11-25', false, 32.286000, 34.853000),
    ('SC-KS-01', 'SuperChampion Kfar Saba',     'Kfar Saba',       'Central',   'Supermarket', 1560, '2017-05-09', false, 32.175000, 34.906700),
    ('SC-RAN-01','SuperChampion Raanana',       'Raanana',         'Central',   'Supermarket', 1620, '2016-12-13', false, 32.184700, 34.871200),
    ('SC-PT-01', 'SuperChampion Petah Tikva',   'Petah Tikva',     'Central',   'Hypermarket', 5600, '2015-08-27', false, 32.087100, 34.887700),
    ('SC-RSH-01','SuperChampion Rishon LeZion', 'Rishon LeZion',   'Central',   'Hypermarket', 6100, '2014-10-02', false, 31.971700, 34.789400),
    ('SC-RHV-01','SuperChampion Rehovot',       'Rehovot',         'Central',   'Supermarket', 1530, '2019-03-28', false, 31.894700, 34.811800),
    ('SC-ASH-01','SuperChampion Ashdod',        'Ashdod',          'Southern',  'Hypermarket', 5900, '2016-02-10', false, 31.804200, 34.655300),
    ('SC-BS-01', 'SuperChampion Beer Sheva',    'Beer Sheva',      'Southern',  'Hypermarket', 5700, '2015-06-15', false, 31.252100, 34.791500),
    ('SC-EIL-01','SuperChampion Eilat',         'Eilat',           'Southern',  'Supermarket', 1480, '2018-09-19', true,  29.557700, 34.951900),
    ('SC-NAZ-01','SuperChampion Nazareth',      'Nazareth',        'Northern',  'Supermarket', 1610, '2017-11-07', false, 32.701200, 35.303500),
    ('SC-TIB-01','SuperChampion Tiberias',      'Tiberias',        'Northern',  'Supermarket', 1370, '2019-04-04', true,  32.794800, 35.532000),
    ('SC-AFU-01','SuperChampion Afula',         'Afula',           'Northern',  'Supermarket', 1450, '2018-07-23', false, 32.609300, 35.290100);

-- ----------------------------------------------------------------------------
-- dim_product : ~60 grocery SKUs (Israeli brands). unit_cost & base velocity derived.
-- ----------------------------------------------------------------------------
INSERT INTO dwh.dim_product
    (sku, product_name, category, subcategory, brand, unit_cost, unit_price, base_daily_units, is_kosher, supplier_name)
SELECT
    sku, name, category, subcat, brand,
    round((price * (0.58 + random()*0.17))::numeric, 2) AS unit_cost,
    price AS unit_price,
    round((
        (CASE category
            WHEN 'Dairy'            THEN 70
            WHEN 'Bakery'           THEN 78
            WHEN 'Produce'          THEN 62
            WHEN 'Beverages'        THEN 46
            WHEN 'Snacks'           THEN 52
            WHEN 'Meat & Fish'      THEN 24
            WHEN 'Frozen'           THEN 30
            WHEN 'Household'        THEN 20
            WHEN 'Health & Beauty'  THEN 16
            WHEN 'Wine & Spirits'   THEN 11
            WHEN 'Pantry'           THEN 36
            ELSE 25
         END) * (0.7 + random()*0.6))::numeric, 1) AS base_daily_units,
    kosher, supplier
FROM (VALUES
    -- Dairy (Tnuva, Tara, Yotvata)
    ('SKU-1001','Milk 3% 1L',                 'Dairy','Milk',          'Tnuva',     7.20, true,  'Tnuva'),
    ('SKU-1002','Cottage Cheese 5% 250g',     'Dairy','Cheese',        'Tnuva',     6.90, true,  'Tnuva'),
    ('SKU-1003','White Cheese 9% 250g',       'Dairy','Cheese',        'Tara',      7.50, true,  'Tara'),
    ('SKU-1004','Yellow Cheese Emek 200g',    'Dairy','Cheese',        'Tnuva',    16.90, true,  'Tnuva'),
    ('SKU-1005','Yogurt Vanilla 150g',        'Dairy','Yogurt',        'Yoplait',   4.50, true,  'Tnuva'),
    ('SKU-1006','Butter 200g',                'Dairy','Butter',        'Tnuva',     9.90, true,  'Tnuva'),
    ('SKU-1007','Chocolate Milk 1L',          'Dairy','Milk',          'Tara',      8.40, true,  'Tara'),
    -- Bakery
    ('SKU-1101','White Bread Sliced',         'Bakery','Bread',        'Angel',     6.50, true,  'Angel Bakeries'),
    ('SKU-1102','Whole Wheat Bread',          'Bakery','Bread',        'Berman',    7.90, true,  'Berman'),
    ('SKU-1103','Pita Bread 10pk',            'Bakery','Flatbread',    'Angel',     8.50, true,  'Angel Bakeries'),
    ('SKU-1104','Challah',                    'Bakery','Bread',        'Berman',   12.90, true,  'Berman'),
    ('SKU-1105','Bourekas Cheese 6pk',        'Bakery','Pastry',       'Angel',    14.90, true,  'Angel Bakeries'),
    ('SKU-1106','Croissant 4pk',              'Bakery','Pastry',       'Roladin',  16.90, true,  'Roladin'),
    -- Produce
    ('SKU-1201','Tomatoes 1kg',               'Produce','Vegetables',  'Local',     6.90, true,  'Agrexco'),
    ('SKU-1202','Cucumbers 1kg',              'Produce','Vegetables',  'Local',     5.90, true,  'Agrexco'),
    ('SKU-1203','Bananas 1kg',                'Produce','Fruit',       'Local',     8.90, true,  'Agrexco'),
    ('SKU-1204','Apples Pink Lady 1kg',       'Produce','Fruit',       'Local',    11.90, true,  'Agrexco'),
    ('SKU-1205','Potatoes 2kg',               'Produce','Vegetables',  'Local',     9.90, true,  'Agrexco'),
    ('SKU-1206','Onions 1kg',                 'Produce','Vegetables',  'Local',     4.90, true,  'Agrexco'),
    ('SKU-1207','Bell Peppers 1kg',           'Produce','Vegetables',  'Local',    12.90, true,  'Agrexco'),
    ('SKU-1208','Avocado 500g',               'Produce','Fruit',       'Local',    10.90, true,  'Agrexco'),
    -- Meat & Fish
    ('SKU-1301','Chicken Breast 1kg',         'Meat & Fish','Poultry', 'Of Tov',   34.90, true,  'Of Tov'),
    ('SKU-1302','Whole Chicken 1.5kg',        'Meat & Fish','Poultry', 'Of Tov',   29.90, true,  'Of Tov'),
    ('SKU-1303','Ground Beef 500g',           'Meat & Fish','Beef',    'Tnuva',    32.90, true,  'Tnuva Meat'),
    ('SKU-1304','Beef Entrecote 1kg',         'Meat & Fish','Beef',    'Premium',  89.90, true,  'Tnuva Meat'),
    ('SKU-1305','Salmon Fillet 500g',         'Meat & Fish','Fish',    'Dag Frost',49.90, true,  'Dag Frost'),
    ('SKU-1306','Chicken Schnitzel 700g',     'Meat & Fish','Poultry', 'Of Tov',   28.90, true,  'Of Tov'),
    -- Frozen
    ('SKU-1401','Frozen Pizza Margherita',    'Frozen','Ready Meals',  'Dr Oetker',18.90, true,  'Dr Oetker'),
    ('SKU-1402','Frozen Mixed Vegetables 800g','Frozen','Vegetables',  'Sunfrost', 13.90, true,  'Sunfrost'),
    ('SKU-1403','Ice Cream Vanilla 1L',       'Frozen','Dessert',      'Strauss',  21.90, true,  'Strauss'),
    ('SKU-1404','Frozen Fries 1kg',           'Frozen','Potato',       'Sunfrost', 12.90, true,  'Sunfrost'),
    ('SKU-1405','Malawach 5pk',               'Frozen','Pastry',       'Tnuva',    17.90, true,  'Tnuva'),
    -- Beverages
    ('SKU-1501','Coca-Cola 1.5L',             'Beverages','Soft Drink','Coca-Cola', 7.90, true,  'Central Bottling'),
    ('SKU-1502','Prigat Orange Juice 1L',     'Beverages','Juice',     'Prigat',    8.90, true,  'Prigat'),
    ('SKU-1503','Mineral Water 6x1.5L',       'Beverages','Water',     'Neviot',   15.90, true,  'Neviot'),
    ('SKU-1504','Tapuzina Orange 1.5L',       'Beverages','Soft Drink','Tapuzina',  7.50, true,  'Jafora'),
    ('SKU-1505','Wissotzky Tea 25 bags',      'Beverages','Hot Drink', 'Wissotzky',12.90, true,  'Wissotzky'),
    ('SKU-1506','Elite Turkish Coffee 200g',  'Beverages','Hot Drink', 'Elite',    16.90, true,  'Strauss'),
    -- Snacks
    ('SKU-1601','Bamba 80g',                  'Snacks','Salty',        'Osem',      4.50, true,  'Osem'),
    ('SKU-1602','Bissli Grill 70g',           'Snacks','Salty',        'Osem',      4.50, true,  'Osem'),
    ('SKU-1603','Pretzels 200g',              'Snacks','Salty',        'Osem',      6.90, true,  'Osem'),
    ('SKU-1604','Milk Chocolate 100g',        'Snacks','Chocolate',    'Elite',     6.50, true,  'Strauss'),
    ('SKU-1605','Wafers Chocolate',           'Snacks','Sweet',        'Elite',     5.90, true,  'Strauss'),
    ('SKU-1606','Potato Chips 150g',          'Snacks','Salty',        'Tapuchips', 8.90, true,  'Strauss'),
    -- Household
    ('SKU-1701','Dish Soap 750ml',            'Household','Cleaning',  'Sano',      9.90, false, 'Sano'),
    ('SKU-1702','Laundry Detergent 3L',       'Household','Cleaning',  'Sano',     32.90, false, 'Sano'),
    ('SKU-1703','Toilet Paper 32 rolls',      'Household','Paper',     'Lily',     39.90, false, 'Hogla-Kimberly'),
    ('SKU-1704','Paper Towels 6 rolls',       'Household','Paper',     'Nikol',    18.90, false, 'Hogla-Kimberly'),
    ('SKU-1705','Garbage Bags 50pk',          'Household','Disposable','Sano',     14.90, false, 'Sano'),
    ('SKU-1706','Bleach 2L',                  'Household','Cleaning',  'Economica', 7.90, false, 'Sano'),
    -- Health & Beauty
    ('SKU-1801','Shampoo 700ml',              'Health & Beauty','Hair','Head&Shoulders',24.90, false,'P&G'),
    ('SKU-1802','Toothpaste 100ml',           'Health & Beauty','Oral','Colgate', 12.90, false, 'Colgate'),
    ('SKU-1803','Bar Soap 4pk',               'Health & Beauty','Body','Dove',    16.90, false, 'Unilever'),
    ('SKU-1804','Deodorant Roll-on',          'Health & Beauty','Body','Rexona',  14.90, false, 'Unilever'),
    ('SKU-1805','Diapers Size 4 44pk',        'Health & Beauty','Baby','Huggies', 49.90, false, 'Hogla-Kimberly'),
    -- Wine & Spirits
    ('SKU-1901','Carmel Selected Red 750ml',  'Wine & Spirits','Wine', 'Carmel',   34.90, true,  'Carmel Winery'),
    ('SKU-1902','Goldstar Beer 6x330ml',      'Wine & Spirits','Beer', 'Goldstar', 32.90, true,  'Tempo'),
    ('SKU-1903','Maccabee Beer 6x330ml',      'Wine & Spirits','Beer', 'Maccabee', 31.90, true,  'Tempo'),
    ('SKU-1904','Arak Elite 700ml',           'Wine & Spirits','Spirits','Elite Arak',39.90,true,'Hacormim'),
    -- Pantry
    ('SKU-2001','Basmati Rice 1kg',           'Pantry','Grains',       'Sugat',    12.90, true,  'Sugat'),
    ('SKU-2002','Spaghetti 500g',             'Pantry','Pasta',        'Osem',      5.90, true,  'Osem'),
    ('SKU-2003','Hummus 400g',                'Pantry','Spreads',      'Sabra',     8.90, true,  'Strauss'),
    ('SKU-2004','Tahini 500g',                'Pantry','Spreads',      'Achva',    16.90, true,  'Achva'),
    ('SKU-2005','Olive Oil 1L',               'Pantry','Oil',          'Yad Mordechai',39.90,true,'Yad Mordechai'),
    ('SKU-2006','Couscous 500g',              'Pantry','Grains',       'Osem',      7.90, true,  'Osem'),
    ('SKU-2007','White Sugar 1kg',            'Pantry','Baking',       'Sugat',     6.90, true,  'Sugat'),
    ('SKU-2008','Flour 1kg',                  'Pantry','Baking',       'Sugat',     5.50, true,  'Sugat')
) AS v(sku, name, category, subcat, brand, price, kosher, supplier);

-- ----------------------------------------------------------------------------
-- dim_employee : ~12-19 staff per store, Israeli names, realistic roles & pay
-- ----------------------------------------------------------------------------
WITH nm AS (
    SELECT
        ARRAY['David','Yossi','Avi','Moshe','Noa','Maya','Tamar','Yael','Daniel','Itai',
              'Shira','Roni','Omer','Liat','Eitan','Gal','Amit','Hila','Or','Tal',
              'Nadav','Michal','Ronen','Sigal','Adi','Lior','Dana','Yarden','Ofir','Shani'] AS fn,
        ARRAY['Cohen','Levi','Mizrahi','Peretz','Biton','Dahan','Avraham','Friedman','Azoulay','Katz',
              'Shapira','Ben-David','Malka','Gabay','Ohayon','Hadad','Amar','Elbaz','Naim','Sasson'] AS ln
),
roster AS (
    SELECT
        s.store_key,
        gs AS n,
        CASE
            WHEN gs = 1            THEN 'Store Manager'
            WHEN gs IN (2,3)       THEN 'Shift Manager'
            WHEN gs IN (4,5)       THEN 'Stocker'
            WHEN gs = 6            THEN 'Butcher'
            WHEN gs = 7            THEN 'Baker'
            WHEN gs = 8            THEN 'Security'
            WHEN gs = 9            THEN 'Cleaner'
            ELSE 'Cashier'
        END AS role
    FROM dwh.dim_store s
    CROSS JOIN generate_series(1, 12 + (s.store_key % 8)) gs
)
INSERT INTO dwh.dim_employee
    (employee_code, full_name, store_key, role, employment_type, hire_date, hourly_rate, is_active)
SELECT
    'EMP-' || lpad((row_number() OVER (ORDER BY r.store_key, r.n))::text, 5, '0'),
    (nm.fn)[1 + floor(random()*array_length(nm.fn,1))] || ' ' ||
    (nm.ln)[1 + floor(random()*array_length(nm.ln,1))],
    r.store_key,
    r.role,
    CASE
        WHEN r.role IN ('Store Manager','Shift Manager') THEN 'Full-time'
        WHEN r.role = 'Cashier' AND random() < 0.5       THEN 'Student'
        WHEN random() < 0.30                             THEN 'Part-time'
        ELSE 'Full-time'
    END,
    date '2021-01-01' + (random()*1612)::int,
    round((CASE r.role
        WHEN 'Store Manager' THEN 80
        WHEN 'Shift Manager' THEN 52
        WHEN 'Butcher'       THEN 46
        WHEN 'Baker'         THEN 44
        WHEN 'Security'      THEN 38
        WHEN 'Cleaner'       THEN 34
        ELSE 34
    END + random()*6)::numeric, 2),
    true
FROM roster r CROSS JOIN nm;
