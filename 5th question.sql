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

-- views v_average_price_growth and v_average_salary_growth already created in the precious 4th question -- 
	
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
	