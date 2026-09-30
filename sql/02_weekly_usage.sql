-- Quantidade e percentual de viagens por dia da semana 

WITH numero_viagens_dia AS (
    SELECT 
        day_of_week,
        day_of_week_name,
        COUNT(*) AS numero_de_viagens
    FROM trips 
    GROUP BY day_of_week, day_of_week_name
)

SELECT 
    day_of_week,
    day_of_week_name,

    REPLACE(
        TO_CHAR(
            numero_de_viagens, 'FM999G999G999'
        ),
        ',',
        '.'
    ) AS numero_de_viagens,

    ROUND(
        numero_de_viagens * 100.0 / SUM(numero_de_viagens) OVER (),
        2
    ) AS percentual_de_viagens

FROM numero_viagens_dia
ORDER BY day_of_week;


-- Comparação entre dias úteis e finais de semana

SELECT
    CASE
        WHEN day_of_week IN (1, 7)
            THEN 'Final de semana'
        ELSE 'Dia útil'
    END AS tipo_dia,
	REPLACE(
		TO_CHAR(
    		COUNT(*), 'FM999G999G999'
		),
		',',
		'.'
	) AS numero_viagens
FROM trips
GROUP BY tipo_dia
ORDER BY numero_viagens DESC;

-- Distribuição de dias úteis vs. finais de semana por tipo de usuário

SELECT
    member_casual,
    CASE
        WHEN day_of_week IN (1, 7)
            THEN 'Final de semana'
        ELSE 'Dia útil'
    END AS tipo_dia,
    REPLACE(
		TO_CHAR(
    		COUNT(*), 'FM999G999G999'
		),
		',',
		'.'
	) AS numero_viagens
FROM trips
GROUP BY member_casual, tipo_dia
ORDER BY member_casual, tipo_dia;


-- Dia da semana com maior número de viagens por tipo de usuário

WITH viagens_por_dia AS (
    SELECT
        member_casual,
        day_of_week,
        day_of_week_name,
        COUNT(*) AS total_viagens,
        ROW_NUMBER() OVER (
            PARTITION BY member_casual
            ORDER BY COUNT(*) DESC
        ) AS posicao
    FROM trips
    GROUP BY member_casual, day_of_week, day_of_week_name
)

SELECT
    member_casual,
    day_of_week,
    day_of_week_name,
	REPLACE(
		TO_CHAR(
    		total_viagens, 'FM999G999G999'
		),
		',',
		'.'
	) AS numero_total_viajens
FROM viagens_por_dia
WHERE posicao = 1
ORDER BY member_casual;


-- Média de viagens por dia da semana por tipo de usuário

WITH viagens_por_dia AS (
    SELECT
        member_casual,
        day_of_week,
        day_of_week_name,
        COUNT(*) AS total_viagens
    FROM trips
    GROUP BY member_casual, day_of_week, day_of_week_name
)

SELECT
    member_casual,
    day_of_week,
    day_of_week_name,
	ROUND(
		AVG(total_viagens), 2
	) AS media_de_viagens
FROM viagens_por_dia
GROUP BY member_casual, day_of_week, day_of_week_name
ORDER BY member_casual, day_of_week, day_of_week_name;
