-- ============================================================
-- 04_ride_duration.sql
-- Análise da duração das viagens
-- ============================================================


-- ============================================================
-- 1. Duração média e mediana por dia da semana
-- ============================================================

SELECT 
	day_of_week,
	day_of_week_name,
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
GROUP BY day_of_week, day_of_week_name
ORDER BY duracao_media_viagens DESC;


-- ============================================================
-- 2. Duração média e mediana por hora
-- ============================================================

SELECT 
	hour,
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
GROUP BY hour
ORDER BY duracao_media_viagens DESC;


-- ============================================================
-- 3. Duração média e mediana por período
-- ============================================================

SELECT 
	CASE
        WHEN hour BETWEEN 0 AND 4 THEN 'Madrugada'
        WHEN hour BETWEEN 5 AND 11 THEN 'Manhã'
        WHEN hour BETWEEN 12 AND 17 THEN 'Tarde'
        ELSE 'Noite'
    END AS periodo_dia,
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
GROUP BY periodo_dia
ORDER BY duracao_media_viagens DESC;


-- ============================================================
-- 4. Duração média e mediana por dia da semana e tipo de usuário
-- ============================================================

SELECT 
	member_casual,
	day_of_week,
	day_of_week_name,
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
GROUP BY 
	member_casual,
	day_of_week,
	day_of_week_name
ORDER BY
	member_casual,
	day_of_week,
	day_of_week_name,
	duracao_media_viagens DESC;


-- ============================================================
-- 5. Duração média e mediana por período e tipo de usuário
-- ============================================================

SELECT 
	member_casual,
	CASE
        WHEN hour BETWEEN 0 AND 4 THEN 'Madrugada'
        WHEN hour BETWEEN 5 AND 11 THEN 'Manhã'
        WHEN hour BETWEEN 12 AND 17 THEN 'Tarde'
        ELSE 'Noite'
    END AS periodo_dia,
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
GROUP BY member_casual, periodo_dia
ORDER BY 
	member_casual, 
	periodo_dia, 
	duracao_media_viagens DESC;


-- ============================================================
-- 6. Duração média e mediana por dia da semana, 
-- hora e tipo de usuário
-- ============================================================

SELECT
    member_casual,
    day_of_week,
    day_of_week_name,
    hour,
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
GROUP BY
    member_casual,
    day_of_week,
    day_of_week_name,
    hour
ORDER BY
    member_casual,
    day_of_week,
    hour;


-- ============================================================
-- 7. Distribuição por faixa de duração
-- ============================================================

WITH distribuicao_faixas AS (
    SELECT
        member_casual,
        CASE
            WHEN ride_length <= 10 THEN 'FAIXA 1 - Até 10 min'
            WHEN ride_length <= 20 THEN 'FAIXA 2 - 11–20 min'
            WHEN ride_length <= 30 THEN 'FAIXA 3 - 21–30 min'
            WHEN ride_length <= 60 THEN 'FAIXA 4 - 31–60 min'
            WHEN ride_length <= 120 THEN 'FAIXA 5 - 61–120 min'
            ELSE 'FAIXA 6 - Mais de 120 min'
        END AS faixa_duracao_min,
        COUNT(*) AS total_viagens
    FROM trips
    GROUP BY member_casual, faixa_duracao_min
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
ORDER BY member_casual, faixa_duracao_min;

