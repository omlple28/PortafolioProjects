
-- porcentaje de muertes por numero de casos
SELECT 
    location,
    date,
    total_cases,
    total_deaths,
    (total_deaths / total_cases) * 100 AS porcentaje
FROM
    covid_deaths
ORDER BY location , date;

-- porcentaje promedio de muertes por continente
SELECT continent,avg((total_deaths/total_cases)*100) as promedio
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY continent;

-- ver casos totales vs poblacion
SELECT 
    location,
    date,
    total_cases,
    population,
    (total_cases / population) * 100 AS porcentaje_p
FROM
    covid_deaths;

-- pais con el mayor indice de contagios 
SELECT 
    location, (total_cases / population) * 100 AS porcentaje
FROM
    covid_deaths
WHERE
    (total_cases / population) * 100 = (SELECT 
            (MAX((total_cases / population) * 100))
        FROM
            covid_deaths);

-- crear tabla temporal de poblacion total y vacunados y obtener el porcentaje de vacunados
-- por país y por dia 

CREATE TEMPORARY TABLE IF NOT EXISTS poblacion_va AS (
	SELECT d.continent,d.location,d.date,d.population,v.new_vaccinations,
		SUM(CAST(v.new_vaccinations AS INT)) OVER(PARTITION BY d.location ORDER BY d.date) AS aumento_vacunados
	FROM covid_deaths d
	JOIN covid_vaccinations v ON d.location=v.location and d.date=v.date
	WHERE d.continent IS NOT NULL
	
)
SELECT *, (aumento_vacunados/population)*100 as porcentaje_vacunados
FROM poblacion_va

