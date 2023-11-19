CREATE OR REPLACE VIEW v_average_salary_growth AS
SELECT  
	salary_year1.year AS year, 
	salary_year1.average_salary,
	salary_year2.year AS previous_year,
	salary_year2.average_salary AS previous_year_salary,
	round(avg((salary_year1.average_salary - salary_year2.average_salary)/salary_year2.average_salary*100),2) AS salary_growth
FROM 
(SELECT 
	jbp.payroll_year AS year,
	round(AVG(jbp.value),2) AS average_salary
FROM t_jiri_beck_project_sql_primary_final jbp 
WHERE jbp.value_type_code = 5958 AND jbp.industry_branch_name IS NOT NULL AND jbp.calculation_code = 200
GROUP BY jbp.payroll_year)salary_year1
JOIN 
(SELECT 
	jbp.payroll_year AS year,
	round(AVG(jbp.value),2) AS average_salary
FROM t_jiri_beck_project_sql_primary_final jbp 
WHERE jbp.value_type_code = 5958 AND jbp.industry_branch_name IS NOT NULL AND jbp.calculation_code = 200
GROUP BY jbp.payroll_year)salary_year2
	ON salary_year1.year = salary_year2.year + 1
GROUP BY salary_year1.year;

SELECT *
FROM v_average_salary_growth;


CREATE OR REPLACE VIEW v_average_price_growth AS
SELECT 	
	price_year1.year AS year,
	price_year1.average_price AS average_price,
	price_year2.year AS previous_year,
	price_year2.average_price AS previous_year_average_price,
	round(avg((price_year1.average_price - price_year2.average_price)/price_year2.average_price *100),2) AS price_growth
FROM
(SELECT	
	YEAR (jbp.date_from) AS year,
	ROUND (AVG (cz_price_value),2) AS average_price
FROM t_jiri_beck_project_sql_primary_final jbp 
GROUP BY YEAR (jbp.date_from))price_year1
JOIN
(SELECT	
	YEAR (jbp.date_from) AS year,
	ROUND (AVG (cz_price_value),2) AS average_price
FROM t_jiri_beck_project_sql_primary_final jbp 
GROUP BY YEAR (jbp.date_from))price_year2
	ON price_year1.year = price_year2.YEAR + 1
GROUP BY price_year1.YEAR;


SELECT *
FROM v_average_price_growth;



SELECT 	vas.year,
		vas.salary_growth,
		vap.price_growth,
		vap.price_growth-vas.salary_growth AS difference,
		CASE
			WHEN vap.price_growth-vas.salary_growth > 10 THEN 1
			ELSE 0
		END	AS diffence_higher_10_percent
FROM v_average_salary_growth vas
JOIN
v_average_price_growth vap
	ON vas.year = vap.YEAR;