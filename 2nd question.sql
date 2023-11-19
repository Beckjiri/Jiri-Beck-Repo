WITH average_price_every_year AS(
	SELECT	
		YEAR(date_from) AS year,
		name AS food_category,
		round(avg(cz_price_value),2) AS average_price,
		price_value,
		price_unit
FROM t_jiri_beck_project_sql_primary_final jbp
WHERE category_code IN (111301, 114201)
GROUP BY YEAR(date_from), name
)
SELECT	
	year2006.food_category,
	year2006.average_price AS average_price_2006,
	year2018.average_price AS average_price_2018,
	year2006.price_value,
	year2006.price_unit,
	year2006s.average_salary_2006,
	year2018s.average_salary_2018,
	round(year2006s.average_salary_2006/year2006.average_price,2) AS monthly_available_amount_2006,
	round(year2018s.average_salary_2018/year2018.average_price,2) AS monthly_available_amount_2018
FROM 
(SELECT	
	year,
	food_category,
	average_price,
	price_value,
	price_unit
FROM average_price_every_year
WHERE year=2006
GROUP BY year, food_category)year2006
JOIN
(SELECT 
	year,
	food_category,
	average_price,
	price_value,
	price_unit
FROM average_price_every_year
WHERE year=2018
GROUP BY year, food_category)year2018
	ON year2006.food_category=year2018.food_category
LEFT JOIN
(SELECT 
	jbp.payroll_year AS year,
	round(AVG(jbp.value),2) AS average_salary_2006
FROM t_jiri_beck_project_sql_primary_final jbp
WHERE jbp.value_type_code = 5958 AND jbp.industry_branch_name IS NOT NULL AND jbp.payroll_year = 2006 AND jbp.calculation_code = 200)year2006s
	ON year2006.year=year2006s.year
LEFT JOIN
(SELECT 
	jbp.payroll_year AS year,
	round(AVG(jbp.value),2) AS average_salary_2018
FROM t_jiri_beck_project_sql_primary_final jbp
WHERE jbp.value_type_code = 5958 AND jbp.industry_branch_name IS NOT NULL AND jbp.payroll_year = 2018 AND jbp.calculation_code = 200)year2018s
	ON year2018.year=year2018s.year;
	
	
	



