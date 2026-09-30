-- ============================================================
-- 01_user_profile.sql
-- Perfil geral e características dos usuários
-- ============================================================


-- ============================================================
-- 1. Consulta inicial
-- Visualização de uma amostra dos registros
-- ============================================================

SELECT *
FROM trips
LIMIT 10;


-- ============================================================
-- 2. Distribuição das viagens por tipo de usuário
-- Quantidade e participação percentual de cada grupo
-- ============================================================

SELECT
    member_casual,
    COUNT(*) AS total_viagens,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percentual_viagens
FROM trips
GROUP BY member_casual
ORDER BY total_viagens DESC;


-- ============================================================
-- 3. Duração média e mediana das viagens por tipo de usuário
-- Permite comparar o comportamento de duração entre os grupos
-- ============================================================

SELECT
    member_casual,
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
GROUP BY member_casual
ORDER BY duracao_media_viagens DESC;


-- ============================================================
-- 4. Tipo de bicicleta utilizado por tipo de usuário
-- Quantidade de viagens realizadas com cada tipo de bicicleta
-- ============================================================

SELECT
    member_casual,

    COUNT(*) FILTER (
        WHERE rideable_type = 'electric_bike'
    ) AS qtd_bicicletas_eletricas,

    COUNT(*) FILTER (
        WHERE rideable_type = 'classic_bike'
    ) AS qtd_bicicletas_classicas

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
        COUNT(*) FILTER (
            WHERE rideable_type = 'electric_bike'
        ) * 100.0 / COUNT(*),
        2
    ) AS percentual_bicicletas_eletricas,

    ROUND(
        COUNT(*) FILTER (
            WHERE rideable_type = 'classic_bike'
        ) * 100.0 / COUNT(*),
        2
    ) AS percentual_bicicletas_classicas

FROM trips
GROUP BY member_casual
ORDER BY member_casual;