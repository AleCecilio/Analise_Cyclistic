-- Consulta Inicial
SELECT *
FROM trips
LIMIT 10;


-- Distribuição das viagens por tipo de usuário
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


-- Duração média e mediana das viagens por tipo de usuário
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


-- Tipo de bicicleta por tipo de usuário
SELECT 
    member_casual,

    REPLACE(
        TO_CHAR(
            COUNT(*) FILTER (
                WHERE rideable_type = 'electric_bike'
            ),
            'FM999G999G999'
        ),
        ',',
        '.'
    ) AS qtd_bicicletas_eletricas,

    REPLACE(
        TO_CHAR(
            COUNT(*) FILTER (
                WHERE rideable_type = 'classic_bike'
            ),
            'FM999G999G999'
        ),
        ',',
        '.'
    ) AS qtd_bicicletas_classicas

FROM trips
GROUP BY member_casual
ORDER BY member_casual;



-- Quantidade de viagens por dia da semana e tipo de usuário

SELECT
    member_casual,

    REPLACE(
        TO_CHAR(
            COUNT(*) FILTER (WHERE day_of_week = 1),
            'FM999G999G999'
        ),
        ',',
        '.'
    ) AS domingo,

    REPLACE(
        TO_CHAR(
            COUNT(*) FILTER (WHERE day_of_week = 2),
            'FM999G999G999'
        ),
        ',',
        '.'
    ) AS segunda_feira,

    REPLACE(
        TO_CHAR(
            COUNT(*) FILTER (WHERE day_of_week = 3),
            'FM999G999G999'
        ),
        ',',
        '.'
    ) AS terca_feira,

    REPLACE(
        TO_CHAR(
            COUNT(*) FILTER (WHERE day_of_week = 4),
            'FM999G999G999'
        ),
        ',',
        '.'
    ) AS quarta_feira,

    REPLACE(
        TO_CHAR(
            COUNT(*) FILTER (WHERE day_of_week = 5),
            'FM999G999G999'
        ),
        ',',
        '.'
    ) AS quinta_feira,

    REPLACE(
        TO_CHAR(
            COUNT(*) FILTER (WHERE day_of_week = 6),
            'FM999G999G999'
        ),
        ',',
        '.'
    ) AS sexta_feira,

    REPLACE(
        TO_CHAR(
            COUNT(*) FILTER (WHERE day_of_week = 7),
            'FM999G999G999'
        ),
        ',',
        '.'
    ) AS sabado

FROM trips
GROUP BY member_casual
ORDER BY member_casual;


-- Hora mais comum de viagem por tipo de usuário

WITH horarios AS (
    SELECT
        member_casual,
        hour,
        COUNT(*) AS total_viagens,
        ROW_NUMBER() OVER (
            PARTITION BY member_casual
            ORDER BY COUNT(*) DESC
        ) AS posicao
    FROM trips
    GROUP BY
        member_casual,
        hour
)

SELECT
    member_casual,
    hour,
    total_viagens
FROM horarios
WHERE posicao <=10
ORDER BY member_casual;
