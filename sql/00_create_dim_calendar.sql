-- ============================================================
-- 00_create_dim_calendar.sql
-- Date and Time Dimension Table (Star Schema)
-- ============================================================

-- Hourly dimension table to support monthly, daily, 
-- hourly, and seasonal bike-share usage analytics.

CREATE TABLE dim_calendar AS
SELECT 
    datum AS datetime_key,                                 -- Primary key (Timestamp ex: 2025-09-01 08:00:00)
    datum::date AS date,                                   -- Truncated date (YYYY-MM-DD)
    EXTRACT(HOUR FROM datum)::integer AS hour,             -- Hour of the day (0 to 23)
    EXTRACT(YEAR FROM datum)::integer AS year,             -- Year (ex: 2025, 2026)
    EXTRACT(MONTH FROM datum)::integer AS month_num,       -- Month number (1 to 12)
    TO_CHAR(datum, 'TMMonth') AS month_name,               -- Month name (ex: September)
    EXTRACT(ISODOW FROM datum)::integer AS day_of_week_num,-- Day of week (1=Monday, 7=Sunday)
    TO_CHAR(datum, 'TMDay') AS day_of_week_name,          -- Day of week name (ex: Monday)
    CASE 
        WHEN EXTRACT(ISODOW FROM datum) IN (6, 7) THEN TRUE 
        ELSE FALSE 
    END AS is_weekend                                     -- Weekend flag (TRUE/FALSE)
FROM generate_series(
    '2025-09-01 00:00:00'::timestamp, 
    '2026-08-31 23:00:00'::timestamp, 
    '1 hour'::interval
) AS datum;

-- Set primary key on the dimension table
ALTER TABLE dim_calendar ADD PRIMARY KEY (datetime_key);