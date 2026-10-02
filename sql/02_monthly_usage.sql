-- ============================================================
-- 02_monthly_usage.sql
-- Análise da utilização mensal e sazonalidade (Star Schema)
-- ============================================================


-- ============================================================
-- 1. Volume total e percentual de viagens por mês
-- Evolução temporal ao longo do período
-- ============================================================

WITH monthly_trips AS (
    SELECT
        d.year,
        d.month_num,
        d.month_name,
        COUNT(*) AS total_trips
    FROM trips t
    JOIN dim_calendar d
      ON DATE_TRUNC('hour', t.started_at) = d.datetime_key
    GROUP BY d.year, d.month_num, d.month_name
)

SELECT
    year,
    month_num,
    month_name,
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
FROM monthly_trips
ORDER BY year, month_num;


-- ============================================================
-- 2. Distribuição mensal de viagens por tipo de usuário
-- Compara a sazonalidade de membros vs. casuais
-- ============================================================

SELECT
    d.year,
    d.month_num,
    d.month_name,
    t.member_casual,
    REPLACE(
        TO_CHAR(
            COUNT(*),
            'FM999G999G999'
        ),
        ',',
        '.'
    ) AS total_trips,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY d.year, d.month_num),
        2
    ) AS monthly_percentage
FROM trips t
JOIN dim_calendar d
  ON DATE_TRUNC('hour', t.started_at) = d.datetime_key
GROUP BY d.year, d.month_num, d.month_name, t.member_casual
ORDER BY d.year, d.month_num, t.member_casual;


-- ============================================================
-- 3. Mês de pico de utilização por tipo de usuário
-- Identifica o mês com maior volume para cada perfil
-- ============================================================

WITH monthly_ranking AS (
    SELECT
        t.member_casual,
        d.year,
        d.month_num,
        d.month_name,
        COUNT(*) AS total_trips,
        ROW_NUMBER() OVER (
            PARTITION BY t.member_casual
            ORDER BY COUNT(*) DESC
        ) AS rank_position
    FROM trips t
    JOIN dim_calendar d
      ON DATE_TRUNC('hour', t.started_at) = d.datetime_key
    GROUP BY t.member_casual, d.year, d.month_num, d.month_name
)

SELECT
    member_casual,
    year,
    month_num,
    month_name,
    REPLACE(
        TO_CHAR(
            total_trips,
            'FM999G999G999'
        ),
        ',',
        '.'
    ) AS total_trips
FROM monthly_ranking
WHERE rank_position = 1
ORDER BY member_casual;


-- ============================================================
-- 4. Duração média e mediana das viagens por mês e tipo de usuário
-- Permite avaliar se a duração das viagens muda com o clima/estação
-- ============================================================

SELECT
    d.year,
    d.month_num,
    d.month_name,
    t.member_casual,
    ROUND(
        AVG(t.ride_length),
        2
    ) AS avg_duration_minutes,
    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY t.ride_length)::numeric,
        2
    ) AS median_duration_minutes
FROM trips t
JOIN dim_calendar d
  ON DATE_TRUNC('hour', t.started_at) = d.datetime_key
GROUP BY d.year, d.month_num, d.month_name, t.member_casual
ORDER BY d.year, d.month_num, t.member_casual;


-- ============================================================
-- 5. Análise por Estação do Ano (Sazonalidade Climática)
-- Agrupa os meses nas quatro estações
-- ============================================================

WITH seasonal_trips AS (
    SELECT
        t.member_casual,
        CASE
            WHEN d.month_num IN (12, 1, 2) THEN 'Winter'
            WHEN d.month_num IN (3, 4, 5) THEN 'Spring'
            WHEN d.month_num IN (6, 7, 8) THEN 'Summer'
            ELSE 'Fall'
        END AS season,
        COUNT(*) AS total_trips,
        ROUND(AVG(t.ride_length), 2) AS avg_duration_minutes
    FROM trips t
    JOIN dim_calendar d
      ON DATE_TRUNC('hour', t.started_at) = d.datetime_key
    GROUP BY t.member_casual, season
)

SELECT
    member_casual,
    season,
    REPLACE(
        TO_CHAR(
            total_trips,
            'FM999G999G999'
        ),
        ',',
        '.'
    ) AS total_trips,
    ROUND(
        total_trips * 100.0 / SUM(total_trips) OVER (PARTITION BY member_casual),
        2
    ) AS percentage_within_group,
    avg_duration_minutes
FROM seasonal_trips
ORDER BY member_casual, total_trips DESC;