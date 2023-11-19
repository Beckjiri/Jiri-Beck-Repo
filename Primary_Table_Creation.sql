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