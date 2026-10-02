-- ============================================================
-- 05_ride_duration.sql
-- Análise da duração das viagens (Star Schema)
-- ============================================================


-- ============================================================
-- 1. Duração média e mediana por dia da semana
-- ============================================================

SELECT 
    d.day_of_week_num AS dia_semana_num,
    d.day_of_week_name AS nome_dia_semana,
    ROUND(
        AVG(t.ride_length), 
        2
    ) AS duracao_media_viagens,
    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY t.ride_length)::numeric,
        2
    ) AS duracao_mediana_viagens
FROM trips t
JOIN dim_calendar d
  ON DATE_TRUNC('hour', t.started_at) = d.datetime_key
GROUP BY d.day_of_week_num, d.day_of_week_name
ORDER BY d.day_of_week_num;


-- ============================================================
-- 2. Duração média e mediana por hora
-- ============================================================

SELECT 
    d.hour AS hora,
    ROUND(
        AVG(t.ride_length), 
        2
    ) AS duracao_media_viagens,
    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY t.ride_length)::numeric,
        2
    ) AS duracao_mediana_viagens
FROM trips t
JOIN dim_calendar d
  ON DATE_TRUNC('hour', t.started_at) = d.datetime_key
GROUP BY d.hour
ORDER BY d.hour;


-- ============================================================
-- 3. Duração média e mediana por período do dia
-- ============================================================

SELECT 
    CASE
        WHEN d.hour BETWEEN 0 AND 4 THEN 'Madrugada'
        WHEN d.hour BETWEEN 5 AND 11 THEN 'Manhã'
        WHEN d.hour BETWEEN 12 AND 17 THEN 'Tarde'
        ELSE 'Noite'
    END AS periodo_dia,
    ROUND(
        AVG(t.ride_length), 
        2
    ) AS duracao_media_viagens,
    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY t.ride_length)::numeric,
        2
    ) AS duracao_mediana_viagens
FROM trips t
JOIN dim_calendar d
  ON DATE_TRUNC('hour', t.started_at) = d.datetime_key
GROUP BY periodo_dia
ORDER BY duracao_media_viagens DESC;


-- ============================================================
-- 4. Duração média e mediana por dia da semana e tipo de usuário
-- ============================================================

SELECT 
    t.member_casual,
    d.day_of_week_num AS dia_semana_num,
    d.day_of_week_name AS nome_dia_semana,
    ROUND(
        AVG(t.ride_length), 
        2
    ) AS duracao_media_viagens,
    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY t.ride_length)::numeric,
        2
    ) AS duracao_mediana_viagens
FROM trips t
JOIN dim_calendar d
  ON DATE_TRUNC('hour', t.started_at) = d.datetime_key
GROUP BY 
    t.member_casual,
    d.day_of_week_num,
    d.day_of_week_name
ORDER BY
    t.member_casual,
    d.day_of_week_num;


-- ============================================================
-- 5. Duração média e mediana por período do dia e tipo de usuário
-- ============================================================

SELECT 
    t.member_casual,
    CASE
        WHEN d.hour BETWEEN 0 AND 4 THEN 'Madrugada'
        WHEN d.hour BETWEEN 5 AND 11 THEN 'Manhã'
        WHEN d.hour BETWEEN 12 AND 17 THEN 'Tarde'
        ELSE 'Noite'
    END AS periodo_dia,
    ROUND(
        AVG(t.ride_length), 
        2
    ) AS duracao_media_viagens,
    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY t.ride_length)::numeric,
        2
    ) AS duracao_mediana_viagens
FROM trips t
JOIN dim_calendar d
  ON DATE_TRUNC('hour', t.started_at) = d.datetime_key
GROUP BY t.member_casual, periodo_dia
ORDER BY 
    t.member_casual, 
    duracao_media_viagens DESC;


-- ============================================================
-- 6. Duração média e mediana por dia da semana, hora e tipo de usuário
-- ============================================================

SELECT
    t.member_casual,
    d.day_of_week_num AS dia_semana_num,
    d.day_of_week_name AS nome_dia_semana,
    d.hour AS hora,
    ROUND(
        AVG(t.ride_length),
        2
    ) AS duracao_media_viagens,
    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY t.ride_length)::numeric,
        2
    ) AS duracao_mediana_viagens
FROM trips t
JOIN dim_calendar d
  ON DATE_TRUNC('hour', t.started_at) = d.datetime_key
GROUP BY
    t.member_casual,
    d.day_of_week_num,
    d.day_of_week_name,
    d.hour
ORDER BY
    t.member_casual,
    d.day_of_week_num,
    hora;


-- ============================================================
-- 7. Distribuição por faixa de duração
-- ============================================================

WITH distribuicao_faixas AS (
    SELECT
        member_casual,
        CASE
            WHEN ride_length <= 10  THEN 1
            WHEN ride_length <= 20  THEN 2
            WHEN ride_length <= 30  THEN 3
            WHEN ride_length <= 60  THEN 4
            WHEN ride_length <= 120 THEN 5
            ELSE 6
        END AS ordem_faixa,
        CASE
            WHEN ride_length <= 10  THEN 'FAIXA 1 - Até 10 min'
            WHEN ride_length <= 20  THEN 'FAIXA 2 - 11–20 min'
            WHEN ride_length <= 30  THEN 'FAIXA 3 - 21–30 min'
            WHEN ride_length <= 60  THEN 'FAIXA 4 - 31–60 min'
            WHEN ride_length <= 120 THEN 'FAIXA 5 - 61–120 min'
            ELSE 'FAIXA 6 - Mais de 120 min'
        END AS faixa_duracao_min,
        COUNT(*) AS total_viagens
    FROM trips
    GROUP BY member_casual, ordem_faixa, faixa_duracao_min
)

SELECT
    member_casual,
    faixa_duracao_min,
    REPLACE(
        TO_CHAR(
            total_viagens,
            'FM999G999G999'
        ),
        ',',
        '.'
    ) AS total_viagens,
    ROUND(
        total_viagens * 100.0
        / SUM(total_viagens) OVER (
            PARTITION BY member_casual
        ),
        2
    ) AS percentual_viagens
FROM distribuicao_faixas
ORDER BY member_casual, ordem_faixa;