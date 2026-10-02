-- ============================================================
-- 04_hourly_usage.sql
-- Análise da utilização ao longo do dia (Star Schema)
-- ============================================================


-- ============================================================
-- 1. Quantidade de viagens por hora
-- ============================================================

SELECT
    d.hour,
    REPLACE(
        TO_CHAR(
            COUNT(*),
            'FM999G999G999'
        ),
        ',',
        '.'
    ) AS total_trips
FROM trips t
JOIN dim_calendar d
  ON DATE_TRUNC('hour', t.started_at) = d.datetime_key
GROUP BY d.hour
ORDER BY d.hour;


-- ============================================================
-- 2. Quantidade de viagens por hora e tipo de usuário
-- ============================================================

SELECT
    t.member_casual,
    d.hour,
    REPLACE(
        TO_CHAR(
            COUNT(*),
            'FM999G999G999'
        ),
        ',',
        '.'
    ) AS total_trips
FROM trips t
JOIN dim_calendar d
  ON DATE_TRUNC('hour', t.started_at) = d.datetime_key
GROUP BY t.member_casual, d.hour
ORDER BY t.member_casual, d.hour;


-- ============================================================
-- 3. Horário de maior utilização por tipo de usuário
-- ============================================================

WITH hourly_ranking AS (
    SELECT
        t.member_casual,
        d.hour,
        COUNT(*) AS total_trips,
        ROW_NUMBER() OVER (
            PARTITION BY t.member_casual
            ORDER BY COUNT(*) DESC
        ) AS rank_position
    FROM trips t
    JOIN dim_calendar d
      ON DATE_TRUNC('hour', t.started_at) = d.datetime_key
    GROUP BY t.member_casual, d.hour
)

SELECT
    member_casual,
    hour,
    REPLACE(
        TO_CHAR(
            total_trips,
            'FM999G999G999'
        ),
        ',',
        '.'
    ) AS total_trips
FROM hourly_ranking
WHERE rank_position = 1
ORDER BY member_casual;


-- ============================================================
-- 4. Distribuição por período do dia e tipo de usuário
-- ============================================================

SELECT
    t.member_casual,
    d.time_of_day,
    REPLACE(
        TO_CHAR(
            COUNT(*),
            'FM999G999G999'
        ),
        ',',
        '.'
    ) AS total_trips
FROM trips t
JOIN dim_calendar d
  ON DATE_TRUNC('hour', t.started_at) = d.datetime_key
GROUP BY t.member_casual, d.time_of_day
ORDER BY t.member_casual, COUNT(*) DESC;


-- ============================================================
-- 5. Distribuição por período do dia, tipo de dia e tipo de usuário
-- ============================================================

SELECT
    t.member_casual,
    CASE
        WHEN d.is_weekend THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    d.time_of_day,
    REPLACE(
        TO_CHAR(
            COUNT(*),
            'FM999G999G999'
        ),
        ',',
        '.'
    ) AS total_trips
FROM trips t
JOIN dim_calendar d
  ON DATE_TRUNC('hour', t.started_at) = d.datetime_key
GROUP BY t.member_casual, d.is_weekend, d.time_of_day
ORDER BY t.member_casual, day_type, COUNT(*) DESC;