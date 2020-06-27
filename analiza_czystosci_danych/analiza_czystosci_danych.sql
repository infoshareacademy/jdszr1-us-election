
--Analiza czystoœci danych projektu us_election -- opis:
-- wykonane zosta³y 4 kroki
--1) 
-- sprawdzenie licznoœci tabel -- licznoœci pola po ktorym bedziemy ³¹czyæ dwie tabele
-- => wniosek, z tabeli county_facts zosta³y wykasowane dane, to powoduje, ¿e w tabeli county_facts s¹ wartoœci, których nie ma w primary_results
-- => wniosek, w tabeli county_facts znajduj¹ siê wpisy, które nie s¹ wykorzystane w tabeli primary_results
-- 2)
-- kontrola wartoœci null / pustych pól
-- a)
-- jedno hrabstwo "New Hampshire" nie mia³o ¿adnej wartoœci w polu fips w tabeli primary_results pr (100 wierszy)
-- => zmiana w danych: uzupe³nienie danych fips w tabeli primary_results pr, danymi z tabeli county_facts cf
-- b)
-- puste pola w kolumnie cf.state_abbreviation w tabeli counties, która powsta³a na bazie tabeli county_facts
-- puste pola wystêpuj¹ na poziomie stanów i dla US
-- pole jest uzupe³nione na poziomie hrabstw    
-- => zmiana w danych: zast¹pienie pustych pól wartoœci¹ "null"
-- 3) 
-- potwierdzenie poprawnosci typu danych liczbowych
-- 4)
-- analiza poprawnoœci/spójnoœci danych wpisu w polu fips vs nazwy hrabstw
-- a)
-- weryfikacja spójnoœci danych fips w tabelach primary_results i counties
-- trzy niespójne przypisania pola fips vs nazwy hrabstwa (36085, 46113, 36047)
-- => zmiana: te wartoœci fips bêd¹ w trakcie analizy wykluczne
-- b)
-- ró¿nica w licznoœci unikatowych nazw hrabstw vs unikatowe wartoœci fips w obu analizowanych tabelach
-- (unikatowych wartoœci fips jest wiêcej ni¿ nazw hrabstw)
-- =>potwierdzenie tezy, ¿e wystêpuje kilka takich samych nazw hrabstw z ró¿nymi wartoœciami fips (takie same nazwy miejscowoœci)
-- 5)
-- test czy wpisy siê nie powtarzaj¹ w tabeli primary_results pr
-- => dane nie powtarzaj¹ siê

-- Analiza:

--1) 

-- licznoœci tabel -- licznoœci pola po ktorym bedziemy ³¹czyæ dwie tabele
 SELECT
	*
FROM
	county_facts cf ;
-- fibs -- klucz g³ówny
 SELECT
	*
FROM
	county_facts_dictionary cfd ;

SELECT
	*
FROM
	primary_results pr ;
-- fibs -- klucz obcy(nieoznaczony - nie ma ustawionego powi¹zania)
 SELECT
	count(DISTINCT fips)
FROM
	county_facts cf ;
--3195
 SELECT
	count(DISTINCT fips)
FROM
	primary_results pr ;
--4207
-- => wniosek, z tabeli county_facts zosta³y wykasowane dane, to powoduje, 

-- ¿e w tabeli county_facts s¹ wartoœci, których nie ma w primary_results
 SELECT
	4207-3195;
--1012 

--1410
 SELECT
	count(*)
FROM
	(
	SELECT
		DISTINCT fips
	FROM
		primary_results pr
EXCEPT
	SELECT
		DISTINCT fips
	FROM
		county_facts cf) a ;
--397
 SELECT
	count(*)
FROM
	(
	SELECT
		DISTINCT fips
	FROM
		county_facts cf
EXCEPT
	SELECT
		DISTINCT fips
	FROM
		primary_results pr) a ;

SELECT
	1410-397;
--1013 (ró¿nica o null)
-- => wniosek, w tabeli county_facts znajduj¹ siê wpisy, które nie s¹ wykorzystane w tabeli primary_results


-- 2)
-- kontrola wartoœci null / pustych pól

-- analiza tabeli primary_results
 SELECT
	count(*)
FROM
	primary_results pr
WHERE
	pr.fips IS NULL;
--100 --int4
 SELECT
	count(*)
FROM
	primary_results pr
WHERE
	pr.candidate IS NULL;
--0 --text
 SELECT
	count(*)
FROM
	primary_results pr
WHERE
	pr.county IS NULL;
--0 --text
 SELECT
	count(*)
FROM
	primary_results pr
WHERE
	pr.fraction_votes IS NULL;
--0 --numeric
 SELECT
	count(*)
FROM
	primary_results pr
WHERE
	pr.party IS NULL;
--0 --text
 SELECT
	count(*)
FROM
	primary_results pr
WHERE
	pr.state IS NULL;
--0 --text
 SELECT
	count(*)
FROM
	primary_results pr
WHERE
	pr.state_abbreviation IS NULL;
--0 --text
 SELECT
	count(*)
FROM
	primary_results pr
WHERE
	pr.votes IS NULL;
--0 --int4

-- select count(*) from primary_results pr where pr.fips like ''; --0 --int4
 SELECT
	count(*)
FROM
	primary_results pr
WHERE
	pr.candidate LIKE '';
--0 --text
 SELECT
	count(*)
FROM
	primary_results pr
WHERE
	pr.county LIKE '';
--0 --text

-- select count(*) from primary_results pr where pr.fraction_votes like ''; --0 --numeric
 SELECT
	count(*)
FROM
	primary_results pr
WHERE
	pr.party LIKE '';
--0 --text
 SELECT
	count(*)
FROM
	primary_results pr
WHERE
	pr.state LIKE '';
--0 --text
 SELECT
	count(*)
FROM
	primary_results pr
WHERE
	pr.state_abbreviation LIKE '';
--0 --text
-- select count(*) from primary_results pr where pr.votes like ''; --0 --int4

-- analiza tabeli counties, która powsta³a na bazie tabeli county_facts
 SELECT
	*
FROM
	counties;

SELECT
	count(*)
FROM
	counties;
--3195
 SELECT
	count(*)
FROM
	counties cf
WHERE
	cf.fips IS NULL;
--0
 SELECT
	count(*)
FROM
	counties cf
WHERE
	cf.area_name IS NULL;
--0
 SELECT
	count(*)
FROM
	counties cf
WHERE
	cf.state_abbreviation IS NULL;
--0
 SELECT
	count(*)
FROM
	counties cf
WHERE
	cf.population IS NULL;
--0
 SELECT
	count(*)
FROM
	counties cf
WHERE
	cf.age_over65 IS NULL;
--0
 SELECT
	count(*)
FROM
	counties cf
WHERE
	cf.female IS NULL;
--0
 SELECT
	count(*)
FROM
	counties cf
WHERE
	cf.white IS NULL;
--0
 SELECT
	count(*)
FROM
	counties cf
WHERE
	cf.black IS NULL;
--0
 SELECT
	count(*)
FROM
	counties cf
WHERE
	cf.indian_or_alaska IS NULL;
--0
 SELECT
	count(*)
FROM
	counties cf
WHERE
	cf.asian IS NULL;
--0
 SELECT
	count(*)
FROM
	counties cf
WHERE
	cf.hawaii_and_pacific IS NULL;
--0
 SELECT
	count(*)
FROM
	counties cf
WHERE
	cf.many_races IS NULL;
--0
 SELECT
	count(*)
FROM
	counties cf
WHERE
	cf.not_white IS NULL;
--0
 SELECT
	count(*)
FROM
	counties cf
WHERE
	cf.hispanic_latino IS NULL;
--0
 SELECT
	count(*)
FROM
	counties cf
WHERE
	cf.white_not_hispanic_or_latino IS NULL;
--0
 SELECT
	count(*)
FROM
	counties cf
WHERE
	cf.foreign_born IS NULL;
--0
 SELECT
	count(*)
FROM
	counties cf
WHERE
	cf.other_language_home IS NULL;
--0
 SELECT
	count(*)
FROM
	counties cf
WHERE
	cf.education_highschool_or_higher IS NULL;
--0
 SELECT
	count(*)
FROM
	counties cf
WHERE
	cf.education_bachelor_or_higher IS NULL;
--0
 SELECT
	count(*)
FROM
	counties cf
WHERE
	cf.veterans IS NULL;
--0
 SELECT
	count(*)
FROM
	counties cf
WHERE
	cf.income_per_capita_12months IS NULL;
--0
 SELECT
	count(*)
FROM
	counties cf
WHERE
	cf.income_household_median IS NULL;
--0
--	select count(*) from counties cf where cf.fips like '';

--  select count(*) from counties cf where cf.area_name like '';
 SELECT
	count(*)
FROM
	counties cf
WHERE
	cf.state_abbreviation LIKE '';
--52
--  select count(*) from counties cf where cf.population like '';
--  select count(*) from counties cf where cf.age_over65 like '';
--  select count(*) from counties cf where cf.female like '';
--  select count(*) from counties cf where cf.white like '';
--  select count(*) from counties cf where cf.black like '';
--  select count(*) from counties cf where cf.indian_or_alaska like '';
--  select count(*) from counties cf where cf.asian like '';
--  select count(*) from counties cf where cf.hawaii_and_pacific like '';
--  select count(*) from counties cf where cf.many_races like '';
--  select count(*) from counties cf where cf.not_white like '';
--  select count(*) from counties cf where cf.hispanic_latino like '';
--  select count(*) from counties cf where cf.white_not_hispanic_or_latino like '';
--  select count(*) from counties cf where cf.foreign_born like '';
--  select count(*) from counties cf where cf.other_language_home like '';
--  select count(*) from counties cf where cf.education_highschool_or_higher like '';
--  select count(*) from counties cf where cf.education_bachelor_or_higher like '';
--  select count(*) from counties cf where cf.veterans like '';
--  select count(*) from counties cf where cf.income_per_capita_12months like '';
--  select count(*) from counties cf where cf.income_household_median like '';
----------------------------------------------

--pole kluczowe fips
 SELECT
	count(*)
FROM
	primary_results pr
WHERE
	pr.fips IS NULL;
--100 

--jedno hrabstwo "New Hampshire" nie ma ¿adnej wartoœci w polu fips w tabeli primary_results pr (100 wierszy)
 SELECT
	count(*)
FROM
	primary_results pr
WHERE
	pr.fips IS NULL;
--100
 SELECT
	count(*)
FROM
	primary_results pr
WHERE
	pr.fips IS NULL
	AND pr.state LIKE '%New Hampshire%' ;
--100
 SELECT
	CASE
		WHEN pr.fips IS NULL THEN 'null'
		ELSE 'wartosc'
	END ile_null_NH ,
	count(*)
FROM
	primary_results pr
WHERE
	pr.state LIKE '%New Hampshire%'
GROUP BY
	CASE
		WHEN pr.fips IS NULL THEN 'null'
		ELSE 'wartosc'
	END;
--state_abbreviation ='NH'
 SELECT
	*
FROM
	county_facts cf
WHERE
	cf.area_name LIKE '%New Hampshire%';
-- fips 33000 - tylko dla cza³ego stanu
 SELECT
	count(*)
FROM
	county_facts cf
WHERE
	cf.state_abbreviation LIKE '%NH%';
-- uzupe³nienie danych fips w tabeli primary_results pr, danymi z tabeli county_facts cf
 UPDATE
	primary_results pr
SET
	fips = (
	SELECT
		ff.fips
	FROM
		(
		SELECT
			DISTINCT cf.fips, lower(SUBSTRING (cf.area_name, 1, 4)) cfan, cf.state_abbreviation
		FROM
			county_facts cf ) ff
	WHERE
		ff.cfan = lower(SUBSTRING (pr.county, 1, 4))
		AND ff.state_abbreviation LIKE '%NH%')
WHERE
	pr.state_abbreviation LIKE '%NH%'
	AND pr.fips IS NULL;

SELECT
	*
FROM
	primary_results prt
WHERE
	prt.state_abbreviation LIKE '%NH%' ;

SELECT
	*
FROM
	primary_results prt
WHERE
	prt.fips IS NULL ;
-----------------------------------------------------------

-- puste pola w kolumnie cf.state_abbreviation w tabeli counties, która powsta³a na bazie tabeli county_facts
 SELECT
	count(*)
FROM
	counties cf
WHERE
	cf.state_abbreviation LIKE '';
--52
 SELECT
	*
FROM
	counties cf
WHERE
	cf.state_abbreviation LIKE '';

-- fips area_name 0 United States 1000 Alabama 2000 Alaska 4000 Arizona 5000 Arkansas 6000 California 8000 Colorado 9000 Connecticut 10000 Delaware 11000 District OF Columbia 12000 Florida 13000 Georgia 15000 Hawaii 16000 Idaho 17000 Illinois 18000 Indiana 19000 Iowa 20000 Kansas 21000 Kentucky 22000 Louisiana 23000 Maine 24000 Maryland 25000 Massachusetts 26000 Michigan 27000 Minnesota 28000 Mississippi 29000 Missouri 30000 Montana 31000 Nebraska 32000 Nevada 33000 NEW Hampshire 34000 NEW Jersey 35000 NEW Mexico 36000 NEW York 37000 North Carolina 38000 North Dakota 39000 Ohio 40000 Oklahoma 41000 Oregon 42000 Pennsylvania 44000 Rhode Island 45000 South Carolina 46000 South Dakota 47000 Tennessee 48000 Texas 49000 Utah 50000 Vermont 51000 Virginia 53000 Washington 54000 West Virginia 55000 Wisconsin 56000 Wyoming
-- pole jest uzupe³nione na poziomie hrabstw 
-- puste pola wystêpuj¹ na poziomie stanów i dla US

-- zast¹pienie pustych pól wartoœci¹ "null"
 UPDATE
	counties cf
SET
	state_abbreviation = NULL
WHERE
	cf.state_abbreviation LIKE '';

SELECT
	count(*)
FROM
	counties cf
WHERE
	cf.state_abbreviation IS NULL;
--52


-- 3) analiza poprawnosci typu danych liczbowych

-- primary_results
 SELECT
	sum(pr.fips)
FROM
	primary_results pr;
--OK
 SELECT
	sum(pr.fraction_votes)
FROM
	primary_results pr;
--OK
 SELECT
	sum(pr.votes)
FROM
	primary_results pr;
--OK

-- counties
 SELECT
	sum(cf.fips)
FROM
	counties cf;
--OK
-- select sum(cf.area_name)  from counties cf;

-- select sum(cf.state_abbreviation)  from counties cf ;
 SELECT
	sum(cf.population)
FROM
	counties cf ;
--OK
 SELECT
	sum(cf.age_over65)
FROM
	counties cf ;
--OK
 SELECT
	sum(cf.female)
FROM
	counties cf ;
--OK
 SELECT
	sum(cf.white)
FROM
	counties cf ;
--OK
 SELECT
	sum(cf.black)
FROM
	counties cf ;
--OK
 SELECT
	sum(cf.indian_or_alaska)
FROM
	counties cf ;
--OK
 SELECT
	sum(cf.asian)
FROM
	counties cf ;
--OK
 SELECT
	sum(cf.hawaii_and_pacific)
FROM
	counties cf ;
--OK
 SELECT
	sum(cf.many_races)
FROM
	counties cf ;
--OK
 SELECT
	sum(cf.not_white)
FROM
	counties cf ;
--OK
 SELECT
	sum(cf.hispanic_latino)
FROM
	counties cf ;
--OK
 SELECT
	sum(cf.white_not_hispanic_or_latino)
FROM
	counties cf ;
--OK
 SELECT
	sum(cf.foreign_born)
FROM
	counties cf;
--OK
 SELECT
	sum(cf.other_language_home)
FROM
	counties cf ;
--OK
 SELECT
	sum(cf.education_highschool_or_higher)
FROM
	counties cf ;
--OK
 SELECT
	sum(cf.education_bachelor_or_higher)
FROM
	counties cf ;
--OK
 SELECT
	sum(cf.veterans)
FROM
	counties cf ;
--OK
 SELECT
	sum(cf.income_per_capita_12months)
FROM
	counties cf ;
--OK
 SELECT
	sum(cf.income_household_median)
FROM
	counties cf;
--OK


-- 4)
-- analiza poprawnoœci/spójnoœci danych wpisu w polu fips vs nazwy hrabstw
-- weryfikacja spójnoœci danych fips w tabelach primary_results i counties
 WITH pr_abb AS (
SELECT
	DISTINCT pr.fips, pr.county, lower(SUBSTRING (pr.county, 1, 4)) co
FROM
	primary_results pr ) ,
count_abb AS (
SELECT
	DISTINCT c.fips, c.area_name, lower(SUBSTRING (c.area_name, 1, 4)) an
FROM
	counties c )
SELECT
	*
FROM
	pr_abb pra,
	count_abb cna
WHERE
	pra.fips = cna.fips
	AND pra.co <> cna.an;
-- => wniosek trzy niespójne przypisania pola fips i nazwy hrabstwa 
--- te pola fips bêd¹ w trakcie analizy wykluczne
--36085	Staten Island	stat	36085	Richmond County	rich
--46113	Oglala Lakota	ogla	46113	Shannon County	shan
--36047	Brooklyn	    broo	36047	Kings County	king
-- => wystepuj¹ równie¿ nazwy miast wielokrotnie siê powtarzaj¹ce z ró¿nymi wielkoœciami fips 

-- (s¹ to rózne miejscowoœci o tej samej nazwie) - bêd¹ brane pod uwagê w analizie
 SELECT
	count(DISTINCT county)
FROM
	primary_results pr
WHERE
	pr.county IS NOT NULL
	AND fips IS NOT NULL;
--2633
 SELECT
	count(DISTINCT cf1.area_name)
FROM
	counties cf1
WHERE
	cf1.area_name IS NOT NULL
	AND fips IS NOT NULL;
--1929
 SELECT
	count(DISTINCT fips)
FROM
	primary_results pr
WHERE
	pr.county IS NOT NULL
	AND fips IS NOT NULL;
--4217
 SELECT
	count(DISTINCT fips)
FROM
	counties cf1
WHERE
	cf1.area_name IS NOT NULL
	AND fips IS NOT NULL;
--3195
 SELECT
	4217 - 2633;
--1584 -- primary result
 SELECT
	3195 - 1929;
--1266 -- counties

-- => teza, w obu tabelach istniej¹ identyczne nazwy hrabstw, które maj¹ inny znacznik fips  
 SELECT
	count(county)
FROM
	(
	SELECT
		DISTINCT pr2.fips, pr2.county
	FROM
		primary_results pr
	JOIN primary_results pr2 ON
		lower(trim(pr.county))= lower(trim(pr2.county))
	WHERE
		pr2.fips <> pr.fips ) pr;
--2195
 SELECT
	count(DISTINCT pr2.county)
FROM
	primary_results pr
JOIN primary_results pr2 ON
	lower(trim(pr.county))= lower(trim(pr2.county))
WHERE
	pr2.fips <> pr.fips ;
--611
 SELECT
	2195-611;
--1584 => potwierdzenie tezy dla tabeli primary_results

-- ile jest unikatowych par - fips&area_name
 SELECT
	count(area_name)
FROM
	(
	SELECT
		DISTINCT cf2.fips, cf2.area_name
	FROM
		counties cf1
	JOIN counties cf2 ON
		trim(lower(cf1.area_name)) = trim(lower(cf2.area_name))
	WHERE
		cf2.fips <> cf1.fips) an
	-- 1692

-- ile jest unikatowych area_name
 SELECT
	count(DISTINCT cf2.area_name)
FROM
	counties cf1
JOIN counties cf2 ON
	trim(lower(cf1.area_name)) = trim(lower(cf2.area_name))
WHERE
	cf2.fips <> cf1.fips;
--426 
 SELECT
	1692-426;
--1266 => potwierdzenie tezy dla tabeli counties

----- test czy wpisy siê nie powtarzaj¹ w tabeli primary_results pr
 SELECT
	pr.fips,
	pr.candidate,
	pr.county,
	pr.candidate,
	pr.votes,
	pr.state_abbreviation,
	pr.state,
	pr.party,
	pr.fraction_votes ,
	count(*)
FROM
	primary_results pr,
	primary_results pr2
WHERE
	pr.candidate = pr2.candidate
	AND pr.county = pr2.county
	AND pr.fips = pr2.fips
	AND pr.fraction_votes = pr2.fraction_votes
	AND pr.party = pr2.party
	AND pr.state = pr2.state
	AND pr.state_abbreviation = pr2.state_abbreviation
	AND pr.votes = pr2.votes
	AND pr.fips = 1001
GROUP BY
	pr.fips,
	pr.candidate,
	pr.county,
	pr.candidate,
	pr.votes,
	pr.state_abbreviation,
	pr.state,
	pr.party,
	pr.fraction_votes
HAVING
	count(*)>1;

SELECT
	pr.fips,
	pr.candidate,
	pr.county,
	pr.candidate,
	pr.votes,
	pr.state_abbreviation,
	pr.state,
	pr.party,
	pr.fraction_votes
FROM
	primary_results pr,
	primary_results pr2
WHERE
	pr.candidate = pr2.candidate
	AND pr.county = pr2.county
	AND pr.fips = pr2.fips
	AND pr.fraction_votes = pr2.fraction_votes
	AND pr.party = pr2.party
	AND pr.state = pr2.state
	AND pr.state_abbreviation = pr2.state_abbreviation
	AND pr.votes = pr2.votes
	AND pr.fips = 1001;


--5)

-- test czy wpisy siê nie powtarzaj¹ w tabeli primary_results pr
 SELECT
	pr.fips,
	pr.candidate,
	pr.county,
	pr.candidate,
	pr.votes,
	pr.state_abbreviation,
	pr.state,
	pr.party,
	pr.fraction_votes ,
	count(*)
FROM
	primary_results pr,
	primary_results pr2
WHERE
	pr.candidate = pr2.candidate
	AND pr.county = pr2.county
	AND pr.fips = pr2.fips
	AND pr.fraction_votes = pr2.fraction_votes
	AND pr.party = pr2.party
	AND pr.state = pr2.state
	AND pr.state_abbreviation = pr2.state_abbreviation
	AND pr.votes = pr2.votes
	--	AND pr.fips = 1001

	GROUP BY pr.fips,
	pr.candidate,
	pr.county,
	pr.candidate,
	pr.votes,
	pr.state_abbreviation,
	pr.state,
	pr.party,
	pr.fraction_votes
HAVING
	count(*)>1;