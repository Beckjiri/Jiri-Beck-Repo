CREATE OR REPLACE TABLE t_jiri_beck_project_SQL_secondary_final
SELECT 	c.country,
		e.`year`, 
		e.GDP,
		e.gini,
		e.population
FROM countries c 
JOIN economies e 
	ON c.country = e.country
WHERE c.continent = 'Europe' AND e.year BETWEEN 2006 AND 2018;
	
SELECT *
FROM t_jiri_beck_project_SQL_secondary_final;