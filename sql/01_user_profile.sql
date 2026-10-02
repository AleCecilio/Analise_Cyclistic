-- ============================================================
-- 01_user_profile.sql
-- Perfil geral e características dos usuários (Star Schema)
-- ============================================================


-- ============================================================
-- 1. Consulta inicial
-- Visualização de uma amostra dos registros das tabelas
-- ============================================================

-- Tabela de Fatos: Trips
SELECT *
FROM trips
LIMIT 10;

-- Tabela de Dimensão: Dim Calendar
SELECT *
FROM dim_calendar
LIMIT 10;


-- ============================================================
-- 2. Distribuição das viagens por tipo de usuário
-- Quantidade e participação percentual de cada grupo
-- ============================================================

SELECT
    member_casual,
    REPLACE(
        TO_CHAR(
            COUNT(*),
            'FM999G999G999'
        ),
        ',',
        '.'
    ) AS total_trips,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage_of_total
FROM trips
GROUP BY member_casual
ORDER BY COUNT(*) DESC;


-- ============================================================
-- 3. Duração média e mediana das viagens por tipo de usuário
-- Permite comparar o comportamento de duração entre os grupos
-- ============================================================

SELECT
    member_casual,
    ROUND(
        AVG(ride_length),
        2
    ) AS avg_duration_minutes,
    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY ride_length)::numeric,
        2
    ) AS median_duration_minutes
FROM trips
GROUP BY member_casual
ORDER BY avg_duration_minutes DESC;


-- ============================================================
-- 4. Tipo de bicicleta utilizado por tipo de usuário
-- Quantidade de viagens realizadas com cada tipo de bicicleta
-- ============================================================

SELECT
    member_casual,
    REPLACE(
        TO_CHAR(
            COUNT(*) FILTER (WHERE rideable_type = 'electric_bike'),
            'FM999G999G999'
        ),
        ',',
        '.'
    ) AS electric_bike_trips,
    REPLACE(
        TO_CHAR(
            COUNT(*) FILTER (WHERE rideable_type = 'classic_bike'),
            'FM999G999G999'
        ),
        ',',
        '.'
    ) AS classic_bike_trips
FROM trips
GROUP BY member_casual
ORDER BY member_casual;


-- ============================================================
-- 5. Participação dos tipos de bicicleta dentro de cada grupo
-- Permite comparar a preferência relativa de members e casuals
-- ============================================================

SELECT
    member_casual,
    ROUND(
        COUNT(*) FILTER (WHERE rideable_type = 'electric_bike') * 100.0 / COUNT(*),
        2
    ) AS percentage_electric_bikes,
    ROUND(
        COUNT(*) FILTER (WHERE rideable_type = 'classic_bike') * 100.0 / COUNT(*),
        2
    ) AS percentage_classic_bikes
FROM trips
GROUP BY member_casual
ORDER BY member_casual;