-- ============================================================
-- 06_station_analysis.sql
-- Análise das estações e rotas (Star Schema)
-- ============================================================

-- ============================================================
-- 1. Total de estações distintas utilizadas
-- Considera origem e destino, ignorando valores nulos ou vazios
-- ============================================================

WITH estacoes_consolidadas AS (
    SELECT start_station_name AS estacao_nome
    FROM trips
    WHERE start_station_name IS NOT NULL AND start_station_name <> ''
    
    UNION
    
    SELECT end_station_name AS estacao_nome
    FROM trips
    WHERE end_station_name IS NOT NULL AND end_station_name <> ''
)

SELECT
    REPLACE(
        TO_CHAR(
            COUNT(DISTINCT estacao_nome),
            'FM999G999G999'
        ),
        ',',
        '.'
    ) AS total_estacoes_utilizadas
FROM estacoes_consolidadas;


-- ============================================================
-- 2. Estações de início com maior volume de viagens
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
WHERE start_station_name IS NOT NULL
GROUP BY start_station_name
ORDER BY COUNT(*) DESC
LIMIT 10;


-- ============================================================
-- 3. Estações de fim com maior volume de viagens
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
WHERE end_station_name IS NOT NULL
GROUP BY end_station_name
ORDER BY COUNT(*) DESC
LIMIT 10;


-- ============================================================
-- 4. Estações com maior duração média das viagens
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
WHERE start_station_name IS NOT NULL
GROUP BY start_station_name
HAVING COUNT(*) >= 100
ORDER BY duracao_media_viagens DESC
LIMIT 10;


-- ============================================================
-- 5. Estações com menor duração média das viagens
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
WHERE start_station_name IS NOT NULL
GROUP BY start_station_name
HAVING COUNT(*) >= 100
ORDER BY duracao_media_viagens ASC
LIMIT 10;


-- ============================================================
-- 6. Estação de início mais utilizada por dia da semana
-- ============================================================

WITH viagens_por_estacao AS (
    SELECT
        d.day_of_week_num AS dia_semana_num,
        d.day_of_week_name AS nome_dia_semana,
        t.member_casual,
        t.start_station_name,
        COUNT(*) AS total_viagens,
        ROW_NUMBER() OVER (
            PARTITION BY
                d.day_of_week_num,
                t.member_casual
            ORDER BY COUNT(*) DESC
        ) AS posicao
    FROM trips t
    JOIN dim_calendar d
      ON DATE_TRUNC('hour', t.started_at) = d.datetime_key
    WHERE t.start_station_name IS NOT NULL
    GROUP BY
        d.day_of_week_num,
        d.day_of_week_name,
        t.member_casual,
        t.start_station_name
)

SELECT
    dia_semana_num,
    nome_dia_semana,
    member_casual,
    start_station_name,
    REPLACE(
        TO_CHAR(
            total_viagens,
            'FM999G999G999'
        ),
        ',',
        '.'
    ) AS total_viagens
FROM viagens_por_estacao
WHERE posicao = 1
ORDER BY
    dia_semana_num,
    member_casual;


-- ============================================================
-- 7. Total de rotas distintas (Pares Origem -> Destino)
-- Considera a direção e ignora viagens sem origem ou destino
-- ============================================================

SELECT
    REPLACE(
        TO_CHAR(
            COUNT(DISTINCT (start_station_name || ' -> ' || end_station_name)),
            'FM999G999G999'
        ),
        ',',
        '.'
    ) AS total_rotas_distintas
FROM trips
WHERE start_station_name IS NOT NULL AND start_station_name <> ''
  AND end_station_name IS NOT NULL AND end_station_name <> '';


-- ============================================================
-- 8. Rota mais utilizada no geral (Líder Global)
-- ============================================================

SELECT
    start_station_name || ' -> ' || end_station_name AS rota,
    REPLACE(
        TO_CHAR(
            COUNT(*),
            'FM999G999G999'
        ),
        ',',
        '.'
    ) AS total_viagens
FROM trips
WHERE start_station_name IS NOT NULL AND start_station_name <> ''
  AND end_station_name IS NOT NULL AND end_station_name <> ''
GROUP BY start_station_name, end_station_name
ORDER BY COUNT(*) DESC
LIMIT 1;


-- ============================================================
-- 9. Rotas mais utilizadas por tipo de usuário
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
    WHERE start_station_name IS NOT NULL
      AND end_station_name IS NOT NULL
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
