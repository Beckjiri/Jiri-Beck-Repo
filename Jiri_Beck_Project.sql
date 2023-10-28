-- Creation of the primary table --

SELECT *
FROM czechia_payroll cp 
LEFT JOIN czechia_payroll_industry_branch cpib 
	ON cp.industry_branch_code = cpib.code 
LEFT JOIN czechia_payroll_calculation cpc 
	ON cp.calculation_code = cpc.code
LEFT JOIN czechia_payroll_unit cpu 
	ON cp.unit_code = cpu.code
LEFT JOIN czechia_payroll_value_type cpvt 
	ON cp.value_type_code = cpvt.code;

SELECT 	min(payroll_year),
		max(payroll_year) 
FROM czechia_payroll cp 
LEFT JOIN czechia_payroll_industry_branch cpib 
	ON cp.industry_branch_code = cpib.code 
LEFT JOIN czechia_payroll_calculation cpc 
	ON cp.calculation_code = cpc.code
LEFT JOIN czechia_payroll_unit cpu 
	ON cp.unit_code = cpu.code
LEFT JOIN czechia_payroll_value_type cpvt 
	ON cp.value_type_code = cpvt.code;



SELECT *
FROM czechia_price cpr
LEFT JOIN czechia_price_category cprc
	ON cpr.category_code = cprc.code; 
	
SELECT	min(YEAR(date_from)),
		max(YEAR(date_from))
FROM czechia_price cpr
LEFT JOIN czechia_price_category cprc
	ON cpr.category_code = cprc.code;



SELECT 	cp.*,
		cpib.name AS industry_branch_name,
		cpc.name AS payroll_calculation_type,
		cpu.name AS unit_name,
		cpvt.name AS value_type_name,
		cpr.*,
		cprc.name, cprc.price_value, cprc.price_unit 
FROM czechia_payroll cp 
LEFT JOIN czechia_payroll_industry_branch cpib 
	ON cp.industry_branch_code = cpib.code 
LEFT JOIN czechia_payroll_calculation cpc 
	ON cp.calculation_code = cpc.code
LEFT JOIN czechia_payroll_unit cpu 
	ON cp.unit_code = cpu.code
LEFT JOIN czechia_payroll_value_type cpvt 
	ON cp.value_type_code = cpvt.code
JOIN czechia_price cpr 
	ON cp.payroll_year = YEAR(cpr.date_from)
JOIN czechia_price_category cprc
	ON cpr.category_code = cprc.code; 

-- the command below is created only to control if the final table is correct while compare the time interval -- 

SELECT 	min(cp.payroll_year),
		max(cp.payroll_year)
FROM czechia_payroll cp 
LEFT JOIN czechia_payroll_industry_branch cpib 
	ON cp.industry_branch_code = cpib.code 
LEFT JOIN czechia_payroll_calculation cpc 
	ON cp.calculation_code = cpc.code
LEFT JOIN czechia_payroll_unit cpu 
	ON cp.unit_code = cpu.code
LEFT JOIN czechia_payroll_value_type cpvt 
	ON cp.value_type_code = cpvt.code
JOIN czechia_price cpr 
	ON cp.payroll_year = YEAR(cpr.date_from)
JOIN czechia_price_category cprc
	ON cpr.category_code = cprc.code;
	

CREATE TABLE t_Jiri_Beck_project_SQL_primary_final
SELECT 	cp.*,
		cpib.name AS industry_branch_name,
		cpc.name AS payroll_calculation_type,
		cpu.name AS unit_name,
		cpvt.name AS value_type_name,
		cpr.id AS cz_price_ID, cpr.value AS cz_price_value, cpr.category_code, cpr.date_from, cpr.date_to, cpr.region_code,  
		cprc.name, cprc.price_value, cprc.price_unit 
FROM czechia_payroll cp 
LEFT JOIN czechia_payroll_industry_branch cpib 
	ON cp.industry_branch_code = cpib.code 
LEFT JOIN czechia_payroll_calculation cpc 
	ON cp.calculation_code = cpc.code
LEFT JOIN czechia_payroll_unit cpu 
	ON cp.unit_code = cpu.code
LEFT JOIN czechia_payroll_value_type cpvt 
	ON cp.value_type_code = cpvt.code
JOIN czechia_price cpr 
	ON cp.payroll_year = YEAR(cpr.date_from)
JOIN czechia_price_category cprc
	ON cpr.category_code = cprc.code
WHERE cp.value IS NOT NULL; 

SELECT *
FROM t_Jiri_Beck_project_SQL_primary_final; 


-- 1 question -- 

-- 1st type of calculation-- 


SELECT 	jbp.industry_branch_name AS branch,
		jbp.payroll_year AS year,
		AVG(jbp.value) AS average_salary
FROM t_jiri_beck_project_sql_primary_final jbp 
WHERE jbp.value_type_code = 5958 AND jbp.industry_branch_name IS NOT NULL AND jbp.calculation_code = 200
GROUP BY jbp.industry_branch_name, jbp.payroll_year
ORDER BY jbp.industry_branch_name, jbp.payroll_year;

-- 2nd type of calculation --

SELECT 	year1.branch,
		round(year1.average_salary_2006,2) AS average_salary_2006,
		round(year2.average_salary_2018,2) AS average_salary_2018,
		CASE 
			WHEN round(year2.average_salary_2018,2)-round(year1.average_salary_2006,2)>0 THEN 'positive_growth'
			ELSE 'negative_growth'
		END AS salary_growth
FROM 
(SELECT	jbp.industry_branch_name AS branch,
		AVG(jbp.value) AS average_salary_2006
FROM t_jiri_beck_project_sql_primary_final jbp 
WHERE jbp.value_type_code = 5958 AND jbp.industry_branch_name IS NOT NULL AND jbp.payroll_year = 2006 AND jbp.calculation_code = 200
GROUP BY jbp.industry_branch_name)year1
JOIN
(SELECT	jbp.industry_branch_name AS branch,
		AVG(jbp.value) AS average_salary_2018
FROM t_jiri_beck_project_sql_primary_final jbp 
WHERE jbp.value_type_code = 5958 AND jbp.industry_branch_name IS NOT NULL AND jbp.payroll_year = 2018 AND jbp.calculation_code = 200
GROUP BY jbp.industry_branch_name)year2 
	ON year1.branch = year2.branch;


-- 2 question --

SELECT 	year2006.food_category,
		year2006.average_price_2006,
		year2018.average_price_2018,
		year2006.price_value,
		year2006.price_unit,
		year2006s.average_salary_2006,
		year2018s.average_salary_2018,
		round(year2006s.average_salary_2006/year2006.average_price_2006,2) AS monthly_available_amount_2006,
		round(year2018s.average_salary_2018/year2018.average_price_2018,2) AS monthly_available_amount_2018
FROM
(SELECT YEAR(date_from) AS year,
		name AS food_category,
		round(avg(cz_price_value),2) AS average_price_2006,
		price_value,
		price_unit
FROM t_jiri_beck_project_sql_primary_final jbp
WHERE category_code IN (111301, 114201) AND YEAR(date_from)=2006
GROUP BY YEAR(date_from), name)year2006
JOIN
(SELECT YEAR(date_from) AS year,
		name AS food_category,
		round(avg(cz_price_value),2) AS average_price_2018,
		price_value,
		price_unit
FROM t_jiri_beck_project_sql_primary_final jbp
WHERE category_code IN (111301, 114201) AND YEAR(date_from)=2018
GROUP BY YEAR(date_from), name)year2018
	ON year2006.food_category=year2018.food_category
LEFT JOIN
(SELECT jbp.payroll_year AS year,
		round(AVG(jbp.value),2) AS average_salary_2006
FROM t_jiri_beck_project_sql_primary_final jbp
WHERE jbp.value_type_code = 5958 AND jbp.industry_branch_name IS NOT NULL AND jbp.payroll_year = 2006 AND jbp.calculation_code = 200)year2006s
	ON year2006.year=year2006s.year
LEFT JOIN
(SELECT jbp.payroll_year AS year,
		round(AVG(jbp.value),2) AS average_salary_2018
FROM t_jiri_beck_project_sql_primary_final jbp
WHERE jbp.value_type_code = 5958 AND jbp.industry_branch_name IS NOT NULL AND jbp.payroll_year = 2018 AND jbp.calculation_code = 200)year2018s
	ON year2018.year=year2018s.YEAR;


-- 3 question --

SELECT 	cyear.food_category,
		cyear.current_year AS year,
		cyear.average_annual_price AS current_year_price,
		cyear2.current_year AS previous_year,
		cyear2.average_annual_price AS previous_year_price,
		round((cyear.average_annual_price - cyear2.average_annual_price)/cyear2.average_annual_price* 100,2)AS price_growth_percent, 
		cyear.price_value,
		cyear.price_unit
FROM
(SELECT jbp.name AS food_category,
		YEAR(jbp.date_from) AS current_year,
		ROUND(AVG(jbp.cz_price_value),2)AS average_annual_price,
		jbp.price_value,
		jbp.price_unit 
FROM t_jiri_beck_project_sql_primary_final jbp
GROUP BY jbp.name, YEAR(jbp.date_from))cyear
JOIN
(SELECT jbp.name AS food_category,
		YEAR(jbp.date_from) AS current_year,
		ROUND(AVG(jbp.cz_price_value),2)AS average_annual_price,
		jbp.price_value,
		jbp.price_unit 
FROM t_jiri_beck_project_sql_primary_final jbp
GROUP BY jbp.name, YEAR(jbp.date_from))cyear2
	ON cyear.food_category = cyear2.food_category
	AND cyear.current_year = cyear2.current_year + 1;
	
-- 1st type of calculation --

SELECT 	cyear.food_category,
		round(avg((cyear.average_annual_price - cyear2.average_annual_price)/cyear2.average_annual_price* 100),2) AS average_price_growth_percent,
		cyear.price_value,
		cyear.price_unit
FROM
(SELECT jbp.name AS food_category,
		YEAR(jbp.date_from) AS current_year,
		ROUND(AVG(jbp.cz_price_value),2)AS average_annual_price,
		jbp.price_value,
		jbp.price_unit 
FROM t_jiri_beck_project_sql_primary_final jbp
GROUP BY jbp.name, YEAR(jbp.date_from))cyear
JOIN
(SELECT jbp.name AS food_category,
		YEAR(jbp.date_from) AS current_year,
		ROUND(AVG(jbp.cz_price_value),2)AS average_annual_price,
		jbp.price_value,
		jbp.price_unit 
FROM t_jiri_beck_project_sql_primary_final jbp
GROUP BY jbp.name, YEAR(jbp.date_from))cyear2
	ON cyear.food_category = cyear2.food_category
	AND cyear.current_year = cyear2.current_year + 1
GROUP BY cyear.food_category
ORDER BY average_price_growth_percent;
		

-- 2nd type of calculation --

SELECT 	start_year.food_category,
		start_year.average_price_2006,
		end_year.average_price_2018,
		ROUND((end_year.average_price_2018-start_year.average_price_2006)/start_year.average_price_2006,2) AS price_growth,
  		start_year.price_value,
  		start_year.price_unit
FROM
(SELECT jbp.name AS food_category,
		ROUND(AVG(jbp.cz_price_value),2)AS average_price_2006,
		jbp.price_value,
		jbp.price_unit 
FROM t_jiri_beck_project_sql_primary_final jbp
WHERE YEAR(jbp.date_from) = 2006
GROUP BY jbp.name) start_year
JOIN 
(SELECT jbp.name AS food_category,
		ROUND(AVG(jbp.cz_price_value),2)AS average_price_2018,
		jbp.price_value,
		jbp.price_unit 
FROM t_jiri_beck_project_sql_primary_final jbp
WHERE YEAR(jbp.date_from) = 2018
GROUP BY jbp.name) end_year
	ON start_year.food_category = end_year.food_category
ORDER BY price_growth;


-- 4 question --

CREATE OR REPLACE VIEW v_average_salary_growth AS
SELECT  salary_year1.year AS year, 
		salary_year1.average_salary,
		salary_year2.year AS previous_year,
		salary_year2.average_salary AS previous_year_salary,
		round(avg((salary_year1.average_salary - salary_year2.average_salary)/salary_year2.average_salary*100),2) AS salary_growth
FROM 
(SELECT jbp.payroll_year AS year,
		round(AVG(jbp.value),2) AS average_salary
FROM t_jiri_beck_project_sql_primary_final jbp 
WHERE jbp.value_type_code = 5958 AND jbp.industry_branch_name IS NOT NULL AND jbp.calculation_code = 200
GROUP BY jbp.payroll_year)salary_year1
JOIN 
(SELECT jbp.payroll_year AS year,
		round(AVG(jbp.value),2) AS average_salary
FROM t_jiri_beck_project_sql_primary_final jbp 
WHERE jbp.value_type_code = 5958 AND jbp.industry_branch_name IS NOT NULL AND jbp.calculation_code = 200
GROUP BY jbp.payroll_year)salary_year2
	ON salary_year1.year = salary_year2.year + 1
GROUP BY salary_year1.year;

SELECT *
FROM v_average_salary_growth;


CREATE OR REPLACE VIEW v_average_price_growth AS
SELECT 	price_year1.year AS year,
		price_year1.average_price AS average_price,
		price_year2.year AS previous_year,
		price_year2.average_price AS previous_year_average_price,
		round(avg((price_year1.average_price - price_year2.average_price)/price_year2.average_price *100),2) AS price_growth
FROM
(SELECT	YEAR (jbp.date_from) AS year,
		ROUND (AVG (cz_price_value),2) AS average_price
FROM t_jiri_beck_project_sql_primary_final jbp 
GROUP BY YEAR (jbp.date_from))price_year1
JOIN
(SELECT	YEAR (jbp.date_from) AS year,
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
	
	
-- 5 question --
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


CREATE OR REPLACE VIEW v_average_GDP_growth AS
SELECT 	gdp_year1.country,
		gdp_year1.year AS year,
		gdp_year1.GDP,
		gdp_year2.year AS previous_year,
		gdp_year2.GDP AS GDP_previous_year,
		round((((gdp_year1.GDP-gdp_year2.GDP)/gdp_year2.GDP) * 100),2)AS GDP_growth
FROM
(SELECT *
FROM t_jiri_beck_project_SQL_secondary_final jbs
WHERE jbs.country = 'Czech Republic' AND jbs.year BETWEEN 2006 AND 2018)gdp_year1
JOIN
(SELECT *
FROM t_jiri_beck_project_SQL_secondary_final jbs
WHERE jbs.country = 'Czech Republic' AND jbs.year BETWEEN 2006 AND 2018)gdp_year2
	ON gdp_year1.country = gdp_year2.country
	AND gdp_year1.year = gdp_year2.year + 1;

	
SELECT 	vag.country,
		vag.year,
		vag.GDP_growth,
		vas.salary_growth,
		vap.price_growth		
FROM v_average_GDP_growth vag
JOIN
v_average_price_growth vap
	ON vag.year = vap.YEAR
JOIN
v_average_salary_growth vas
	ON vag.year = vas.YEAR;
	
