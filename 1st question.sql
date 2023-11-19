-- 1st type of calculation-- 

SELECT 	jbp.industry_branch_name AS branch,
		jbp.payroll_year AS year,
		AVG(jbp.value) AS average_salary
FROM 	t_jiri_beck_project_sql_primary_final jbp 
WHERE 	jbp.value_type_code = 5958 AND jbp.industry_branch_name IS NOT NULL AND jbp.calculation_code = 200
GROUP BY jbp.industry_branch_name, jbp.payroll_year
ORDER BY jbp.industry_branch_name, jbp.payroll_year;

-- 2nd type of calculation --

WITH average_salary_every_year AS (
	SELECT	jbp.industry_branch_name AS branch,
			jbp.payroll_year AS year,
			AVG (jbp.value) AS average_salary
	FROM t_jiri_beck_project_sql_primary_final jbp
	WHERE jbp.value_type_code = 5958 AND jbp.industry_branch_name IS NOT NULL AND jbp.calculation_code = 200
	GROUP BY jbp.industry_branch_name, jbp.payroll_year
) 
SELECT 		year1.branch,
			year1.average_salary_2006,
			year2.average_salary_2018,
			CASE
				WHEN round(year2.average_salary_2018,2)-round(year1.average_salary_2006,2)>0 THEN 'positive_growth'
				ELSE 'negative_growth'
			END AS salary_growth
FROM
(SELECT		branch,	
			average_salary AS average_salary_2006
FROM average_salary_every_year
WHERE year = 2006)year1
JOIN
(SELECT		branch,	
			average_salary AS average_salary_2018
FROM average_salary_every_year
WHERE year = 2018)year2
	ON year1.branch = year2.branch







