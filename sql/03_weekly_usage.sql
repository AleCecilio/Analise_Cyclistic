-- ============================================================
-- 03_weekly_usage.sql
-- Análise da utilização ao longo da semana (Star Schema)
-- ============================================================


-- ============================================================
-- 1. Quantidade e percentual de viagens por dia da semana
-- ============================================================

WITH weekly_trips AS (
    SELECT
        d.day_of_week_num,
        d.day_of_week_name,
        COUNT(*) AS total_trips
    FROM trips t
    JOIN dim_calendar d 
      ON DATE_TRUNC('hour', t.started_at) = d.datetime_key
    GROUP BY d.day_of_week_num, d.day_of_week_name
)

SELECT
    day_of_week_num,
    day_of_week_name,
    REPLACE(
        TO_CHAR(
            total_trips,
            'FM999G999G999'
        ),
        ',',
        '.'
    ) AS total_trips,
    ROUND(
        total_trips * 100.0 / SUM(total_trips) OVER (),
        2
    ) AS percentage_of_total
FROM weekly_trips
ORDER BY day_of_week_num;


-- ============================================================
-- 2. Comparação entre dias úteis e finais de semana
-- ============================================================

SELECT
    CASE
        WHEN d.is_weekend THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
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
GROUP BY d.is_weekend
ORDER BY COUNT(*) DESC;


-- ============================================================
-- 3. Distribuição de dias úteis vs. finais de semana por tipo de usuário
-- ============================================================

SELECT
    t.member_casual,
    CASE
        WHEN d.is_weekend THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
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
GROUP BY t.member_casual, d.is_weekend
ORDER BY t.member_casual, day_type;


-- ============================================================
-- 4. Dia da semana com maior número de viagens por tipo de usuário
-- ============================================================

WITH daily_ranking AS (
    SELECT
        t.member_casual,
        d.day_of_week_num,
        d.day_of_week_name,
        COUNT(*) AS total_trips,
        ROW_NUMBER() OVER (
            PARTITION BY t.member_casual
            ORDER BY COUNT(*) DESC
        ) AS rank_position
    FROM trips t
    JOIN dim_calendar d 
      ON DATE_TRUNC('hour', t.started_at) = d.datetime_key
    GROUP BY t.member_casual, d.day_of_week_num, d.day_of_week_name
)

SELECT
    member_casual,
    day_of_week_num,
    day_of_week_name,
    REPLACE(
        TO_CHAR(
            total_trips,
            'FM999G999G999'
        ),
        ',',
        '.'
    ) AS total_trips
FROM daily_ranking
WHERE rank_position = 1
ORDER BY member_casual;


-- ============================================================
-- 5. Média diária de viagens por dia da semana e tipo de usuário
-- (Calcula a média real por ocorrência de cada dia da semana no ano)
-- ============================================================

WITH total_and_days AS (
    SELECT
        t.member_casual,
        d.day_of_week_num,
        d.day_of_week_name,
        COUNT(*) AS total_trips,
        COUNT(DISTINCT d.date) AS days_in_period
    FROM trips t
    JOIN dim_calendar d 
      ON DATE_TRUNC('hour', t.started_at) = d.datetime_key
    GROUP BY t.member_casual, d.day_of_week_num, d.day_of_week_name
)

SELECT
    member_casual,
    day_of_week_num,
    day_of_week_name,
    ROUND(
        total_trips * 1.0 / days_in_period,
        2
    ) AS avg_daily_trips
FROM total_and_days
ORDER BY member_casual, day_of_week_num;