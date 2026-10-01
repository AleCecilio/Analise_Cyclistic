-- ============================================================
-- 04_station_analysis.sql
-- Análise das estações
-- ============================================================


-- ============================================================
-- 1. Estações de início com maior volume de viagens
-- Distribuição das viagens por tipo de usuário
-- ============================================================

SELECT
    start_station_name,
    REPLACE(
        TO_CHAR(
            COUNT(*),
            'FM999G999G999'
        ),
        ',',
        '.'
    ) AS total_viagens,
    ROUND(
        COUNT(*) FILTER (
            WHERE member_casual = 'member'
        ) * 100.0 / COUNT(*),
        2
    ) AS percentual_member,
    ROUND(
        COUNT(*) FILTER (
            WHERE member_casual = 'casual'
        ) * 100.0 / COUNT(*),
        2
    ) AS percentual_casual
FROM trips
GROUP BY start_station_name
ORDER BY COUNT(*) DESC
LIMIT 10;


-- ============================================================
-- 2. Estações de fim com maior volume de viagens
-- Distribuição das viagens por tipo de usuário
-- ============================================================

SELECT
    end_station_name,
    REPLACE(
        TO_CHAR(
            COUNT(*),
            'FM999G999G999'
        ),
        ',',
        '.'
    ) AS total_viagens,
    ROUND(
        COUNT(*) FILTER (
            WHERE member_casual = 'member'
        ) * 100.0 / COUNT(*),
        2
    ) AS percentual_member,
    ROUND(
        COUNT(*) FILTER (
            WHERE member_casual = 'casual'
        ) * 100.0 / COUNT(*),
        2
    ) AS percentual_casual
FROM trips
GROUP BY end_station_name
ORDER BY COUNT(*) DESC
LIMIT 10;


-- ============================================================
-- 3. Estações com maior duração média das viagens
-- ============================================================

SELECT
    start_station_name,
    COUNT(*) AS total_viagens,
    ROUND(
        AVG(ride_length),
        2
    ) AS duracao_media_viagens,
    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY ride_length)::numeric,
        2
    ) AS duracao_mediana_viagens
FROM trips
GROUP BY start_station_name
HAVING COUNT(*) >= 100
ORDER BY duracao_media_viagens DESC
LIMIT 10;


-- ============================================================
-- 4. Estações com menor duração média das viagens
-- ============================================================

SELECT
    start_station_name,
    COUNT(*) AS total_viagens,
    ROUND(
        AVG(ride_length),
        2
    ) AS duracao_media_viagens,
    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY ride_length)::numeric,
        2
    ) AS duracao_mediana_viagens
FROM trips
GROUP BY start_station_name
HAVING COUNT(*) >= 100
ORDER BY duracao_media_viagens ASC
LIMIT 10;


-- ============================================================
-- 5. Estação de início mais utilizada por dia da semana
-- ============================================================

WITH viagens_por_estacao AS (
    SELECT
        day_of_week,
        day_of_week_name,
        member_casual,
        start_station_name,
        COUNT(*) AS total_viagens,
        ROW_NUMBER() OVER (
            PARTITION BY
                day_of_week,
                member_casual
            ORDER BY COUNT(*) DESC
        ) AS posicao
    FROM trips
    WHERE start_station_name IS NOT NULL
    GROUP BY
        day_of_week,
        day_of_week_name,
        member_casual,
        start_station_name
)

SELECT
    day_of_week,
    day_of_week_name,
    member_casual,
    start_station_name,
    total_viagens
FROM viagens_por_estacao
WHERE posicao = 1
ORDER BY
    day_of_week,
    member_casual;


-- ============================================================
-- 6. Rotas mais utilizadas por tipo de usuário
-- ============================================================

WITH rotas AS (
    SELECT
        member_casual,
        start_station_name,
        end_station_name,
        COUNT(*) AS total_viagens,
        ROW_NUMBER() OVER (
            PARTITION BY member_casual
            ORDER BY COUNT(*) DESC
        ) AS posicao
    FROM trips
    GROUP BY
        member_casual,
        start_station_name,
        end_station_name
)

SELECT
    member_casual,
    start_station_name,
    end_station_name,
    REPLACE(
        TO_CHAR(
            total_viagens,
            'FM999G999G999'
        ),
        ',',
        '.'
    ) AS total_viagens
FROM rotas
WHERE posicao <= 10
ORDER BY member_casual, posicao;
