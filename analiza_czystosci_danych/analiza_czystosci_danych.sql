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

-- Analiza:
--1) 
-- licznoœci tabel -- licznoœci pola po ktorym bedziemy ³¹czyæ dwie tabele


   select * from county_facts cf ; -- fibs -- klucz g³ówny
   select * from county_facts_dictionary cfd ;
   select * from primary_results pr ; -- fibs -- klucz obcy(nieoznaczony - nie ma ustawionego powi¹zania)
   

  select count(distinct fips) from county_facts cf ; --3195
  select count(distinct fips) from primary_results pr ; --4207
  -- => wniosek, z tabeli county_facts zosta³y wykasowane dane, to powoduje, 
  -- ¿e w tabeli county_facts s¹ wartoœci, których nie ma w primary_results
  

select 4207-3195; --1012 

  --1410
  select count(*) from (
  select distinct fips from primary_results pr
  except
  select distinct fips from county_facts cf) a ;
  
  --397
  select count(*) from (
  select distinct fips from county_facts cf
  except
  select distinct fips from primary_results pr) a ; 
 
  select 1410-397; --1013 (ró¿nica o null)
 
  -- => wniosek, w tabeli county_facts znajduj¹ siê wpisy, które nie s¹ wykorzystane w tabeli primary_results
  
  -- 2)
  -- kontrola wartoœci null / pustych pól
  
   -- analiza tabeli primary_results
   
   select count(*) from primary_results pr where pr.fips is null; --100 --int4
 select count(*) from primary_results pr where pr.candidate is null; --0 --text
 select count(*) from primary_results pr where pr.county is null; --0 --text
 select count(*) from primary_results pr where pr.fraction_votes is null; --0 --numeric
 select count(*) from primary_results pr where pr.party is null; --0 --text
 select count(*) from primary_results pr where pr.state is null; --0 --text
 select count(*) from primary_results pr where pr.state_abbreviation is null; --0 --text
 select count(*) from primary_results pr where pr.votes is null; --0 --int4
 
-- select count(*) from primary_results pr where pr.fips like ''; --0 --int4
 select count(*) from primary_results pr where pr.candidate like ''; --0 --text
 select count(*) from primary_results pr where pr.county like ''; --0 --text
-- select count(*) from primary_results pr where pr.fraction_votes like ''; --0 --numeric
 select count(*) from primary_results pr where pr.party like ''; --0 --text
 select count(*) from primary_results pr where pr.state like ''; --0 --text
 select count(*) from primary_results pr where pr.state_abbreviation like ''; --0 --text
-- select count(*) from primary_results pr where pr.votes like ''; --0 --int4
 
 -- analiza tabeli counties, która powsta³a na bazie tabeli county_facts
 
 select * from counties; 
 select count(*) from counties; --3195
  
 	select count(*) from counties cf where cf.fips is null; --0
    select count(*) from counties cf where cf.area_name is null; --0
    select count(*) from counties cf where cf.state_abbreviation is null; --0
    select count(*) from counties cf where cf.population is null; --0
    select count(*) from counties cf where cf.age_over65 is null; --0
    select count(*) from counties cf where cf.female is null; --0
    select count(*) from counties cf where cf.white is null; --0
    select count(*) from counties cf where cf.black is null; --0
    select count(*) from counties cf where cf.indian_or_alaska is null; --0
    select count(*) from counties cf where cf.asian is null; --0
    select count(*) from counties cf where cf.hawaii_and_pacific is null; --0
    select count(*) from counties cf where cf.many_races is null; --0
    select count(*) from counties cf where cf.not_white is null; --0
    select count(*) from counties cf where cf.hispanic_latino is null; --0
    select count(*) from counties cf where cf.white_not_hispanic_or_latino is null; --0
    select count(*) from counties cf where cf.foreign_born is null; --0
    select count(*) from counties cf where cf.other_language_home is null; --0
    select count(*) from counties cf where cf.education_highschool_or_higher is null; --0
    select count(*) from counties cf where cf.education_bachelor_or_higher is null; --0
    select count(*) from counties cf where cf.veterans is null; --0
    select count(*) from counties cf where cf.income_per_capita_12months is null; --0
    select count(*) from counties cf where cf.income_household_median is null; --0
    

   
   --	select count(*) from counties cf where cf.fips like '';
  --  select count(*) from counties cf where cf.area_name like '';
    select count(*) from counties cf where cf.state_abbreviation like ''; --52
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
   select count(*) from primary_results pr where pr.fips is null; --100 
 
 --jedno hrabstwo "New Hampshire" nie ma ¿adnej wartoœci w polu fips w tabeli primary_results pr (100 wierszy)
 select count(*) from primary_results pr where pr.fips is null; --100
 select count(*) from primary_results pr where pr.fips is null and pr.state like '%New Hampshire%' ; --100
 
 select 
 case when pr.fips is null then 'null' else 'wartosc' end ile_null_NH
 , count(*) 
 from primary_results pr 
 where pr.state like '%New Hampshire%'
 group by case when pr.fips is null then 'null' else 'wartosc' end; --state_abbreviation ='NH'

 select * from county_facts cf where cf.area_name like '%New Hampshire%'; -- fips 33000 - tylko dla cza³ego stanu
 select count(*) from county_facts cf where cf.state_abbreviation like '%NH%';

 -- uzupe³nienie danych fips w tabeli primary_results pr, danymi z tabeli county_facts cf

update primary_results pr set fips = 
(select ff.fips from
(select distinct cf.fips, lower(SUBSTRING (cf.area_name,1,4)) cfan, cf.state_abbreviation
from county_facts cf ) ff
where ff.cfan=lower(SUBSTRING (pr.county,1,4))
and ff.state_abbreviation like '%NH%')
where pr.state_abbreviation like '%NH%'
and pr.fips is null;

select * 
from primary_results prt 
where  prt.state_abbreviation like '%NH%' ;
select * 
from primary_results prt 
where  prt.fips is null ;

-----------------------------------------------------------
-- puste pola w kolumnie cf.state_abbreviation w tabeli counties, która powsta³a na bazie tabeli county_facts
    select count(*) from counties cf where cf.state_abbreviation like ''; --52

     select * from counties cf where cf.state_abbreviation like ''; 
    
 fips area_name   
 0	United States
1000	Alabama
2000	Alaska
4000	Arizona
5000	Arkansas
6000	California
8000	Colorado
9000	Connecticut
10000	Delaware
11000	District Of Columbia
12000	Florida
13000	Georgia
15000	Hawaii
16000	Idaho
17000	Illinois
18000	Indiana
19000	Iowa
20000	Kansas
21000	Kentucky
22000	Louisiana
23000	Maine
24000	Maryland
25000	Massachusetts
26000	Michigan
27000	Minnesota
28000	Mississippi
29000	Missouri
30000	Montana
31000	Nebraska
32000	Nevada
33000	New Hampshire
34000	New Jersey
35000	New Mexico
36000	New York
37000	North Carolina
38000	North Dakota
39000	Ohio
40000	Oklahoma
41000	Oregon
42000	Pennsylvania
44000	Rhode Island
45000	South Carolina
46000	South Dakota
47000	Tennessee
48000	Texas
49000	Utah
50000	Vermont
51000	Virginia
53000	Washington
54000	West Virginia
55000	Wisconsin
56000	Wyoming
    
    -- pole jest uzupe³nione na poziomie hrabstw 
    -- puste pola wystêpuj¹ na poziomie stanów i dla US
    
    -- zast¹pienie pustych pól wartoœci¹ "null"
    
    update counties cf set state_abbreviation = null
	where cf.state_abbreviation like '';

	select count(*) from counties cf where cf.state_abbreviation is null; --52

-- 3) analiza poprawnosci typu danych liczbowych
-- primary_results
 select sum(pr.fips) from primary_results pr; --OK
 select sum(pr.fraction_votes) from primary_results pr; --OK
 select sum(pr.votes) from primary_results pr; --OK

 -- counties
    select sum(cf.fips) from counties cf; --OK
   -- select sum(cf.area_name)  from counties cf;
   -- select sum(cf.state_abbreviation)  from counties cf ;
    select sum(cf.population)  from counties cf ; --OK
    select sum(cf.age_over65)  from counties cf ; --OK
    select sum(cf.female) from counties cf ; --OK
    select sum(cf.white)  from counties cf ; --OK
    select sum(cf.black)  from counties cf ; --OK
    select sum(cf.indian_or_alaska)  from counties cf ; --OK
    select sum(cf.asian)  from counties cf ; --OK
    select sum(cf.hawaii_and_pacific)  from counties cf ;--OK
    select sum(cf.many_races)  from counties cf ;--OK
    select sum(cf.not_white)  from counties cf ;--OK
    select sum(cf.hispanic_latino)  from counties cf ;--OK
    select sum(cf.white_not_hispanic_or_latino)  from counties cf ; --OK
    select sum(cf.foreign_born)  from counties cf; --OK
    select sum(cf.other_language_home)  from counties cf ; --OK
    select sum(cf.education_highschool_or_higher)  from counties cf ; --OK
    select sum(cf.education_bachelor_or_higher)  from counties cf ; --OK
    select sum(cf.veterans)  from counties cf ; --OK
    select sum(cf.income_per_capita_12months)  from counties cf ; --OK
    select sum(cf.income_household_median)  from counties cf; --OK
    
 
-- 4)
-- analiza poprawnoœci/spójnoœci danych wpisu w polu fips vs nazwy hrabstw

-- weryfikacja spójnoœci danych fips w tabelach primary_results i counties

  with pr_abb as (
   select distinct pr.fips, pr.county, lower(SUBSTRING (pr.county,1,4)) co from primary_results pr
   				 ) 
  , count_abb as (
   select distinct c.fips, c.area_name, lower(SUBSTRING (c.area_name,1,4)) an from counties c
  				 )
  			select * from pr_abb pra, count_abb cna 
  					 where pra.fips=cna.fips
  					 and pra.co<>cna.an;
  					
  	-- => wniosek trzy niespójne przypisania pola fips i nazwy hrabstwa 
  	--- te pola fips bêd¹ w trakcie analizy wykluczne
--36085	Staten Island	stat	36085	Richmond County	rich
--46113	Oglala Lakota	ogla	46113	Shannon County	shan
--36047	Brooklyn	    broo	36047	Kings County	king

    -- => wystepuj¹ równie¿ nazwy miast wielokrotnie siê powtarzaj¹ce z ró¿nymi wielkoœciami fips 
    -- (s¹ to rózne miejscowoœci o tej samej nazwie) - bêd¹ brane pod uwagê w analizie
    
  select count(distinct county) from primary_results pr where pr.county is not null and fips is not null; --2633
  select count(distinct cf1.area_name) from counties cf1 where cf1.area_name is not null and fips is not null; --1929
  
  select count(distinct fips) from primary_results pr where pr.county is not null and fips is not null; --4217
  select count(distinct fips) from counties cf1 where  cf1.area_name  is not null and fips is not null; --3195

  select 4217 - 2633; --1584 -- primary result
  select 3195 - 1929; --1266 -- counties
  
  -- => teza, w obu tabelach istniej¹ identyczne nazwy hrabstw, które maj¹ inny znacznik fips  

  select count(county) from (
  select distinct pr2.fips, pr2.county
  from primary_results pr 
  join primary_results pr2 on lower(trim(pr.county))=lower(trim(pr2.county))
  where  pr2.fips <> pr.fips ) pr; --2195
  
  select count(distinct pr2.county) 
  from primary_results pr 
  join primary_results pr2 on lower(trim(pr.county))=lower(trim(pr2.county))
  where  pr2.fips <> pr.fips ; --611
  
  select 2195-611; --1584 => potwierdzenie tezy dla tabeli primary_results

-- ile jest unikatowych par - fips&area_name
  select count(area_name) from (
  select distinct cf2.fips, cf2.area_name
  from counties cf1 
  join counties cf2 on trim(lower(cf1.area_name)) =trim(lower(cf2.area_name))
  where  cf2.fips <> cf1.fips) an -- 1692
-- ile jest unikatowych area_name
  select count(distinct cf2.area_name)
  from counties cf1 
  join counties cf2 on trim(lower(cf1.area_name)) =trim(lower(cf2.area_name))
  where  cf2.fips <> cf1.fips; --426 

  select 1692-426; --1266 => potwierdzenie tezy dla tabeli counties

  

  
