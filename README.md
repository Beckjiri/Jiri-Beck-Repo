# Jiri-Beck-Repo
Repository for Engeto Academy projects

# Zadání projektu

Na vašem analytickém oddělení nezávislé společnosti, která se zabývá životní úrovní občanů, jste se dohodli, že se pokusíte odpovědět na pár definovaných výzkumných otázek, které adresují dostupnost základních potravin široké veřejnosti. Kolegové již vydefinovali základní otázky, na které se pokusí odpovědět a poskytnout tuto informaci tiskovému oddělení. Toto oddělení bude výsledky prezentovat na následující konferenci zaměřené na tuto oblast.

Potřebují k tomu od vás připravit robustní datové podklady, ve kterých bude možné vidět porovnání dostupnosti potravin na základě průměrných příjmů za určité časové období.

Jako dodatečný materiál připravte i tabulku s HDP, GINI koeficientem a populací dalších evropských států ve stejném období, jako primární přehled pro ČR.

### Výzkumné otázky

1) Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
2) Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
3) Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
4) Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
5) Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?

# Vypracování projektu

## Vyhotovení primární a sekundární tabulky

Jako první jsem si vytvořil tabulku s informacemi o mzdách a cenách v České republice, ze které jsem čerpal informace při vypracování odpovědí na první čtyři otázky. Nejprve jsem si propojil tabulku czechia_payroll s tabulkami, které mají na tuto tabulku vazbu a pomocí funkce MAX a MIN pro atribut payroll_year jsem si vypočítal interval, pro který mam data k dispozici. Stejným způsobem jsem poté propojil tabulku czechia_price s tabulkou czechia_price_category, se kterou má relační vazbu, a zjistil si i zde interval, pro který máme data. Nakonec jsem tabulky czechia_payroll a czechia_price propojil na základě atributu yearcp.payroll_year = YEAR(cpr.date_from), kde jsem použil funkci JOIN (INNER), aby se mi do výsledné tabulky zahrnuly pouze roky společné pro obě dvě tabulky. Finální data tedy pocházela z let 2006-2018. 

Druhou tabulku jsem vytvořil až v rámci úkolu číslo 5, protože dříve jsem s touhle tabulkou obsahující data i pro jiné evropské země nemusel pracovat. V téhle tabulce jsem propojil původní tabulky countries a econimies a vybral hodnoty country, year, GDP, Gini a population. Obě tabulky jsem spojil na základě atributu country, který je společný pro obě dvě tabulky. Vyfiltroval jsem dále pomocí funkce WHERE pouze hodnoty pro evropské země a časový rozpětí od roku 2006 po rok 2018. 

## 1. otázka-Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
Při vypracovávání tohoto úkolů jsem udělal dva různé výpočty. Při prvním z nich jsem v každém odvětví zjistil pro každý rok průměrnou mzdu a hodnoty ve výsledné tabulce seřadil podle odvětví a roku. Ze získaných výpočtů lzde vyčíst, že mzdy ve všech obdobích primárně meziročně rostly. Pouze u těžby a dobývání byla průměrná mzda v následujícím roce třikrát nižší než v předchozím. U jiných období došlo k meziročnímu poklesu maximálně dvakrát a většinou k nikterak výraznému. Největší pokles průměrné mzdy byl zaznamenán v oboru Peněžnictví a pojišťovnictví v roce 2013, kde průměrná mzda klesla z 50.800,50 CZK na 46.316,50. Od roku 2014 mzdy ve všech odvětvích konstantně rostou.
V rámci tohoto úkolu udělal ještě jeden výpočet, kde jsem si zjistil pro každé odvětví průměrnou mzdu za první a poslední rok měřeného období a výsledné hodnoty porovnal pomocí funkce CASE Expression. V případě, že by se za dané období průměrná mzda někde snížila, tak by funkce vrátila hodnotu negative, což se během celého sledovaného období nestalo a v roce 2018 máme mzdy všude vyšší než na začátku, s tím, že nárust je převážně výrazný. 

## 2. otázka-Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
Zde jsem si pro obě období na základě roku a category_code vypočítal pro obě komodity první průměrnou cenu. V roce 2006 stál kg chleba průměrně 16,12 CZK a litr mléka 14,44 CZK. Do roku 2018 se pak průměrná cena u chleba zvedla na 24,24 CZK a u mléka na 19,82 CZK. K růstu ale došlo také co se týče průměrných mezd v České republice a v roce 2018 si člověk mohl obou komodit v průměru koupit více. U chleba přibližně o 52 kg (1.365,16 kg  v roce 2018 a 1.312,98 kg v roce 2006) a u mléka o přibližně o 204 litrů více (1.465,73 l v roce 2006 a 1.669,6 v roce 2018).

## 3. otázka-Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
Při hledání odpovědi na tuto otázku jsem použil také dvě různé metody výpočtu. Nejprve jsem u všech kategorií potravin vypočítal pro každý rok sledovaného období meziroční nárust resp. pokles průměrné ceny. Mohli jsme tedy vidět pohyb cen ve srovnání s předchozím rokem. Následně jsem vypočítané hodnoty zprůměroval a ke každé kategorii jsme mohli tedy vidět její průmerný cenový růst/pokles za dané období. Nejnižší hodnota (-1,92 %) byla zjištěna u krystalového cukru, který za uvedené období slevnil. Naopak u másla a paprik je průměrný meziroční růst cen nejvyšší.
Tyto výsledky byly podpořeny také druhým způsobem výpočtu, kde jsem porovnal ceny za první a poslední sledovaný rok. Opět zde můžeme vidět, že záporný růst byl zaznamenán pouze u cukru a rajčat s tím, že u cukru byl tento cenový pokles nejvýraznější. Průměrná cena klesla od roku 2006 do roku 2018 z 21,73 CZK na 15,75 CZK, což odpovídá přibližně slevnění o 28 %.

## 4. otázka-Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
Zde jsem si udělal jak pro porovnání meziročního růstu mezd tak i pro meziroční růst cen VIEW, kde jsem si mohl porovnat průměrné meziroční změny. Následně jsem oba tyto VIEWs propojil abych si mohl růsty pro obě dvě tato kritéria porovnat. Nárust cen vyšší o 10 % než růst mezd nebyl během sledovanho období zaznamenán. Největší rozdíl ve prospěch cenového nárustu oproti mzdovému byl zaznamenán mezi let 2013 a 2012 ale rozdíl zde byl 7,11 %. V ostatních mezoročních srovnáních pak byly tyto hodnoty vždy nižší.

## 5. otázka-Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?
V rámci tohoho úkolu bylo nejprve třeba si vytvořit sekundární tabulku pro ekonomické údaje evropských zemí. Dále jsem si vyhotovil VIEW pro porovnání růstu HDP v České republice za období od roku 2006 po rok 2018, abych tento mohl následně porovnat s VIEWs obsahujícímí statistiky růstu cen a mezd v témže období. Protože nemáme k dispozici data k růstu cen a mezd pro jiné země než je Česká republika, tak jsem dále s ekonomickými daty jiných zemí už nepracoval. Ve finálním srovnání můžeme vidět, že v roce 2009 byl výrazněší pokles celkové hodnoty HDP doprovázen také vyšším propadem cen. Jelikož se HDP sestavuje z celkového počtu všech vyprodukovaných statků a služeb na území jednoho státu ze určité časové období vyjádřeném v penězích, tak se tato změna dala očekávat. Pro přesnější výpočty by ale bylo třeba obohatit index spotřebitelských cen také o ceny za další položky než potraviny, protože většina důležitých statků a služeb zde nebyla zohledněna. Jistou vazbu můžeme vidět také mezi růstem HDP a růstem mezd, kde na sebe tyto položky často také reagují. Souvislost zde určitě také existuje, protože kupní síla obyvatel dokáže zvýšit poptávku po vyprodukovaných produktech a službách a nakopnout tedy ekonomiku a růst HDP. 
