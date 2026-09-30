-- ============================================================
-- 03_hourly_usage.sql
-- Análise da utilização ao longo do dia
-- ============================================================


-- ============================================================
-- 1. Quantidade de viagens por hora
-- ============================================================

SELECT
    hour,
    REPLACE(
        TO_CHAR(
            COUNT(*),
            'FM999G999G999'
        ),
        ',',
        '.'
    ) AS total_viagens
FROM trips
GROUP BY hour
ORDER BY COUNT(*) DESC;


-- ============================================================
-- 2. Quantidade de viagens por hora e tipo de usuário
-- ============================================================

SELECT
    member_casual,
    hour,
    REPLACE(
        TO_CHAR(
            COUNT(*),
            'FM999G999G999'
        ),
        ',',
        '.'
    ) AS total_viagens
FROM trips
GROUP BY member_casual, hour
ORDER BY member_casual, COUNT(*) DESC;


-- ============================================================
-- 3. Horário de maior utilização por tipo de usuário
-- ============================================================

WITH hora_tipo_usuario AS (
    SELECT
        member_casual,
        hour,
        COUNT(*) AS total_viagens,
        ROW_NUMBER() OVER (
            PARTITION BY member_casual
            ORDER BY COUNT(*) DESC
        ) AS posicao
    FROM trips
    GROUP BY member_casual, hour
)

SELECT
    member_casual,
    hour,
    REPLACE(
        TO_CHAR(
            total_viagens,
            'FM999G999G999'
        ),
        ',',
        '.'
    ) AS total_viagens
FROM hora_tipo_usuario
WHERE posicao = 1
ORDER BY member_casual;


-- ============================================================
-- 4. Distribuição por período do dia e tipo de usuário
-- ============================================================

SELECT
    member_casual,
    CASE
        WHEN hour BETWEEN 0 AND 4 THEN 'Madrugada'
        WHEN hour BETWEEN 5 AND 11 THEN 'Manhã'
        WHEN hour BETWEEN 12 AND 17 THEN 'Tarde'
        ELSE 'Noite'
    END AS periodo_dia,
    REPLACE(
        TO_CHAR(
            COUNT(*),
            'FM999G999G999'
        ),
        ',',
        '.'
    ) AS total_viagens
FROM trips
GROUP BY member_casual, periodo_dia
ORDER BY COUNT(*) DESC;


-- ============================================================
-- 5. Distribuição por período do dia, tipo de dia e tipo de usuário
-- ============================================================

SELECT
    member_casual,
    CASE
        WHEN day_of_week IN (1, 7)
            THEN 'Final de semana'
        ELSE 'Dia útil'
    END AS tipo_dia,
    CASE
        WHEN hour BETWEEN 0 AND 4 THEN 'Madrugada'
        WHEN hour BETWEEN 5 AND 11 THEN 'Manhã'
        WHEN hour BETWEEN 12 AND 17 THEN 'Tarde'
        ELSE 'Noite'
    END AS periodo_dia,
    COUNT(*) AS total_viagens
FROM trips
GROUP BY member_casual, tipo_dia, periodo_dia
ORDER BY member_casual, tipo_dia, total_viagens DESC;