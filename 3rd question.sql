	
-- 1st type of calculation --

WITH average_price_every_year AS (
SELECT 	jbp.name AS food_category,
		YEAR(jbp.date_from) AS year,
		ROUND(AVG(jbp.cz_price_value),2)AS average_annual_price,
		jbp.price_value,
		jbp.price_unit 
FROM t_jiri_beck_project_sql_primary_final jbp
GROUP BY jbp.name, YEAR(jbp.date_from)
)
SELECT 	cyear.food_category,
		round(avg((cyear.average_annual_price - cyear2.average_annual_price)/cyear2.average_annual_price* 100),2) AS average_price_growth_percent,
		cyear.price_value,
		cyear.price_unit
FROM 
(SELECT food_category,
		year,
		average_annual_price,
		price_value,
		price_unit 
FROM average_price_every_year)cyear
JOIN
(SELECT food_category,
		year,
		average_annual_price,
		price_value,
		price_unit 
FROM average_price_every_year)cyear2
	ON cyear.food_category = cyear2.food_category
	AND cyear.year = cyear2.year + 1
GROUP BY cyear.food_category
ORDER BY average_price_growth_percent;
		
-- 2nd type of calculation --


WITH average_price_year AS(
SELECT 	jbp.name AS food_category,
		ROUND(AVG(jbp.cz_price_value),2)AS average_price,
		YEAR(jbp.date_from) AS year,
		jbp.price_value,
		jbp.price_unit
FROM t_jiri_beck_project_sql_primary_final jbp
GROUP BY jbp.name, YEAR(jbp.date_from)
)
SELECT 	start_year.food_category,
		start_year.average_price AS average_price_2006,
		end_year.average_price AS average_price_2018,
		ROUND((end_year.average_price-start_year.average_price)/start_year.average_price,2) AS price_growth,
		start_year.price_value,
  		start_year.price_unit
FROM
(SELECT food_category,
		average_price,
		price_value,
		price_unit
FROM average_price_year
WHERE year = 2006)start_year
JOIN
(SELECT food_category,
		average_price,
		price_value,
		price_unit
FROM average_price_year
WHERE year = 2018)end_year
	ON start_year.food_category = end_year.food_category
ORDER BY price_growth;




