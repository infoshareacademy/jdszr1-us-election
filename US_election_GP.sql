CREATE database us_election;



CREATE TABLE county_facts (
    fips INTEGER PRIMARY KEY,
    area_name TEXT,
    state_abbreviation TEXT,
    PST045214 INTEGER,
    PST040210 INTEGER,
    PST120214 NUMERIC,
    POP010210 INTEGER,
    AGE135214 NUMERIC,
    AGE295214 NUMERIC,
    AGE775214 NUMERIC,
    SEX255214 NUMERIC,
    RHI125214 NUMERIC,  
    RHI225214 NUMERIC,
    RHI325214 NUMERIC,
    RHI425214 NUMERIC,
    RHI525214 NUMERIC,
    RHI625214 NUMERIC,
    RHI725214 NUMERIC,
    RHI825214 NUMERIC,
    POP715213 NUMERIC,
    POP645213 NUMERIC,
    POP815213 NUMERIC,
    EDU635213 NUMERIC,
    EDU685213 NUMERIC,
    VET605213 INTEGER,
    LFE305213 NUMERIC,
    HSG010214 INTEGER,
    HSG445213 NUMERIC,
    HSG096213 NUMERIC,
    HSG495213 INTEGER,
    HSD410213 INTEGER,
    HSD310213 NUMERIC,
    INC910213 INTEGER,
    INC110213 INTEGER,
    PVY020213 NUMERIC,
    BZA010213 INTEGER,
    BZA110213 INTEGER,
    BZA115213 NUMERIC,
    NES010213 INTEGER,
    SBO001207 INTEGER,
    SBO315207 NUMERIC,
    SBO115207 NUMERIC,
    SBO215207 NUMERIC,
    SBO515207 NUMERIC,
    SBO415207 NUMERIC,
    SBO015207 NUMERIC,
    MAN450207 INTEGER,
    WTN220207 INTEGER,
    RTN130207 INTEGER,
    RTN131207 INTEGER,
    AFN120207 INTEGER,
    BPS030214 INTEGER,
    LND110210 NUMERIC,
    POP060210 NUMERIC);
   
   
CREATE TABLE county_facts_dictionary(
    column_name TEXT,
    description TEXT);
   


CREATE TABLE primary_results (
    state TEXT,
    state_abbreviation TEXT,
    county TEXT,
    fips INTEGER,
    party TEXT,
    candidate TEXT,
    votes INTEGER,
    fraction_votes NUMERIC);
   
   select * from primary_results;
  select * from county_facts_dictionary ;
  select * from county_facts;
 select * from counties;
 
 
 - county_facts_dictionary definition

CREATE TABLE county_facts_dictionary(
    column_name TEXT,
    description TEXT);
    


-- county_facts definition

CREATE TABLE county_facts (
    fips INTEGER PRIMARY KEY,
    area_name TEXT,
    state_abbreviation TEXT,
    PST045214 INTEGER,
    PST040210 INTEGER,
    PST120214 NUMERIC,
    POP010210 INTEGER,
    AGE135214 NUMERIC,
    AGE295214 NUMERIC,
    AGE775214 NUMERIC,
    SEX255214 NUMERIC,
    RHI125214 NUMERIC,
    RHI225214 NUMERIC,
    RHI325214 NUMERIC,
    RHI425214 NUMERIC,
    RHI525214 NUMERIC,
    RHI625214 NUMERIC,
    RHI725214 NUMERIC,
    RHI825214 NUMERIC,
    POP715213 NUMERIC,
    POP645213 NUMERIC,
    POP815213 NUMERIC,
    EDU635213 NUMERIC,
    EDU685213 NUMERIC,
    VET605213 INTEGER,
    LFE305213 NUMERIC,
    HSG010214 INTEGER,
    HSG445213 NUMERIC,
    HSG096213 NUMERIC,
    HSG495213 INTEGER,
    HSD410213 INTEGER,
    HSD310213 NUMERIC,
    INC910213 INTEGER,
    INC110213 INTEGER,
    PVY020213 NUMERIC,
    BZA010213 INTEGER,
    BZA110213 INTEGER,
    BZA115213 NUMERIC,
    NES010213 INTEGER,
    SBO001207 INTEGER,
    SBO315207 NUMERIC,
    SBO115207 NUMERIC,
    SBO215207 NUMERIC,
    SBO515207 NUMERIC,
    SBO415207 NUMERIC,
    SBO015207 NUMERIC,
    MAN450207 INTEGER,
    WTN220207 INTEGER,
    RTN130207 INTEGER,
    RTN131207 INTEGER,
    AFN120207 INTEGER,
    BPS030214 INTEGER,
    LND110210 NUMERIC,
    POP060210 NUMERIC);
    
   
 -- primary_results definition

CREATE TABLE primary_results (
    state TEXT,
    state_abbreviation TEXT,
    county TEXT,
    fips INTEGER,
    party TEXT,
    candidate TEXT,
    votes INTEGER,
    fraction_votes NUMERIC);  
   
select * from county_facts cf 
select * from primary_results pr 
   
select distinct(candidate) from primary_results pr 


--Stworzenie nowej tabeli counties, będącej uproszczeniem tabeli county_facts

CREATE TABLE counties as (select
    fips,
    area_name,
    state_abbreviation,
    PST045214 as population,
    AGE775214 as age_over65,
    SEX255214 as female,
    RHI125214 as white,
    RHI225214 as black,
    RHI325214 as indian_or_alaska,
    RHI425214 as asian,
    RHI525214 as hawaii_and_pacific,
    RHI625214 as many_races,
    (RHI225214 + RHI325214 + RHI425214 + RHI525214 + RHI625214)::numeric as not_white,
    RHI725214 as hispanic_latino,
    RHI825214 as white_not_hispanic_or_latino,
    POP645213 as foreign_born,
    POP815213 as other_language_home,
    EDU635213 as education_highschool_or_higher,
    EDU685213 as education_bachelor_or_higher,
    VET605213 as veterans,
    INC910213 as income_per_capita_12months,
    INC110213 as income_household_median
   from county_facts);
  
select * from counties;


-- Utworzenie tabeli candidates, zawierającej dane o kandydatach
  
  create table candidates (
  	candidate text,
  	party text,
  	gender text,
  	rase text,
  	year_of_birth int,
  	age_2016 int  );
  
 
  
 
  	Zadanie nr 1   
  ---zapytanie	nr 1				   -donald j trump  ROKLAD ZE WZGLEDU NA DOCHOD
  	  	
  		----zapytanie pomocnicze  wyliczenie kwantyli wynagrodzenia
  	
 select
percentile_disc(array[0.1, 0.25,  0.5, 0.75, 0.9]) within group (order by income_per_capita_12months ) as
KWanil_01_025_075_09
from counties c 
 ----- kwantyle  przychodu w miastach  {17751,19968,23021,26321,30432}|

select *from counties c2 
select
percentile_disc (array[0.1, 0.25,  0.5, 0.75, 0.9]) within group (order by fraction_votes ) as
KWanile_glosow_01_025_05_075_09
from primary_results 
 where candidate ilike 'Donald%'  
------  kwantyle rozkladu glosowania na d trumpa m {0.27899999999999997,0.35200000000000004,0.455,0.5579999999999999,0.688}
  
  	--- 
  	--ilosc miejscowosci   gdzie  income na 12 mies przkracza percentyl 0.9 czyli 30432 
  	
 
 
  				
  			--------------	
  ----Zadania nr 1 Analiza dla Donalda trumpa 
  
 --- dla analizy stworzono 1 zlozone zapytanie ktorego schemat jest do zastosowania wsrod specyfikowanych dziedzin
 
 
  				Zapytanie nr 1
  		---   Czy wielkolkosc portfela sprawi ze zaglosujesz na milonera/ sprawdzenie lisoci miast pod katem rocznego dochodu 
  		---- dla najchetniej glosujacych na Donalda Trumpa 
 --Zapytania pomocnicze
 
  	--rozklad  percentyli glosow dla donalda trumpa
  		
  				select
percentile_disc (array[0.1, 0.25,  0.5, 0.75, 0.9]) within group (order by fraction_votes ) as
KWanile_glosow_01_025_05_075_09
from primary_results 
 where candidate ilike 'Donald%' 
  --- wunik 
  	kwanile_glosow_01_025_05_075_09                                         |
------------------------------------------------------------------------|
{0.27899999999999997,0.35200000000000004,0.455,0.5579999999999999,0.688}|	

---Zaptyanie pomocnicze   nr 2

---rozkad wynagrodzen w percentylach 01. 025.05.075 0.9

 select
percentile_disc(array[0.1, 0.25,  0.5, 0.75, 0.9]) within group (order	by	income_per_capita_12months) as
KWanil_01_025_05_075_09
from counties c 

kwanil_01_025_05_075_09        |
-------------------------------|
{17751,19968,23021,26321,30432}|


  				
  --zapytania glowne 1 (poczatek)
  	select count(1)  as liczba_miast, (select count(1) ogolna_liczba_miast from primary_results  
  											LEFT  join counties  on primary_results.fips = counties .fips   
  																where	candidate ilike 'Donald%' 
  																and income_per_capita_12months > 
  																( select percentile_disc( 0.9) within group (order by income_per_capita_12months)
  										from counties)) , candidate as Precentyl_glowsow_09_dla_kandydata,
  										( select percentile_disc( 0.9) within group (order by income_per_capita_12months) as dochod_roczny
  										
  													from counties) 
  					
  	from primary_results  
  	LEFT join counties  on primary_results.fips = counties .fips   
  	where	candidate ilike 'Donald%' 
  				and income_per_capita_12months > ( select percentile_disc( 0.9) within group (order by income_per_capita_12months)
  													from counties) 
  				and fraction_votes >( select percentile_disc( 0.9) within group (order by fraction_votes ) 
  									from primary_results  where candidate ilike 'Donald%' ) 
				
  				and county is not null	
  				group by candidate
   	union 
  	select count(1)  as liczba_miast, (select count(1) ogolna_liczba_miast from primary_results  
  											LEFT  join counties  on primary_results.fips = counties .fips   
  																where	candidate ilike 'Donald%' 
  																and income_per_capita_12months <
  																( select percentile_disc( 0.1) within group (order by income_per_capita_12months)
  										from counties)) , candidate as Precentyl_glowsow_09_dla_kandydata,
  										( select percentile_disc( 0.1) within group (order by income_per_capita_12months) as dochod_roczny
  										
  													from counties) 
  					
  	from primary_results  
  	LEFT join counties  on primary_results.fips = counties .fips   
  	where	candidate ilike 'Donald%' 
  				and income_per_capita_12months <( select percentile_disc( 0.1) within group (order by income_per_capita_12months)
  													from counties) 
  				and fraction_votes >( select percentile_disc( 0.9) within group (order by fraction_votes ) 
  									from primary_results  where candidate ilike 'Donald%' ) 
				
  				and county is not null	
  				group by candidate
  	union 
   	select count(1)  as liczba_miast, (select count(1) ogolna_liczba_miast from primary_results  
  											LEFT  join counties  on primary_results.fips = counties .fips   
  																where	candidate ilike 'Donald%' 
  																and income_per_capita_12months >
  																( select percentile_disc( 0.5) within group (order by income_per_capita_12months)
  										from counties)) , candidate as Precentyl_glowsow_09_dla_kandydata,
  										( select percentile_disc( 0.5) within group (order by income_per_capita_12months) as dochod_roczny
  										
  													from counties) 
  					
  	from primary_results  
  	LEFT join counties  on primary_results.fips = counties .fips   
  	where	candidate ilike 'Donald%' 
  				and income_per_capita_12months >( select percentile_disc( 0.5) within group (order by income_per_capita_12months)
  													from counties) 
  				and fraction_votes >( select percentile_disc( 0.9) within group (order by fraction_votes ) 
  									from primary_results  where candidate ilike 'Donald%' ) 
				
  				and county is not null	
  				group by candidate
 union 
  select count(1)  as liczba_miast, (select count(1) ogolna_liczba_miast from primary_results  
  											LEFT  join counties  on primary_results.fips = counties .fips   
  																where	candidate ilike 'Donald%' 
  																and income_per_capita_12months <
  																( select percentile_disc( 0.5) within group (order by income_per_capita_12months)
  										from counties)) , candidate as Precentyl_glowsow_09_dla_kandydata,
  										( select percentile_disc( 0.5) within group (order by income_per_capita_12months) as dochod_roczny
  										
  													from counties) 
  					
  	from primary_results  
  	LEFT join counties  on primary_results.fips = counties .fips   
  	where	candidate ilike 'Donald%' 
  				and income_per_capita_12months <( select percentile_disc( 0.5) within group (order by income_per_capita_12months)
  													from counties) 
  				and fraction_votes >( select percentile_disc( 0.9) within group (order by fraction_votes ) 
  									from primary_results  where candidate ilike 'Donald%' ) 
				
  				and county is not null	
  				group by candidate
   	------- zapytanie 
   	----  wynik   
   	liczba_miast|ogolna_liczba_miast|precentyl_glowsow_09_dla_kandydata|dochod_roczny|
------------|-------------------|----------------------------------|-------------|
          23|                313|Donald Trump                      |        17751|
         150|               1501|Donald Trump                      |        23021|
         176|               1209|Donald Trump                      |        23021|
          39|                197|Donald Trump                      |        30432|
   	
 -----  wnioski  Zarabjajacy powyzej sredniej wykazuja wieksze tendencje do glosowania na DJ TRUMPA 
 ---- w przypadku odsetka najbardziej bogatych tendencja rosnie w gore
  
   	
   	Zapytanie nr 2
   	
   --- Czy poziom edykacji ma wpylyw na wybor kandydata w przypadku D.J.TRUMPA
   
   	
   	zaptytanie 
   	select
percentile_disc (array[0.1, 0.25,  0.5, 0.75, 0.9]) within group (order by fraction_votes ) as
KWanile_glosow_01_025_05_075_09
from primary_results 
 where candidate ilike 'Donald%' 
  --- wynik 
  
 
 --kwantyle glowso na D J TRUMPA
  	kwanile_glosow_01_025_05_075_09                                         |
------------------------------------------------------------------------|
{0.27899999999999997,0.35200000000000004,0.455,0.5579999999999999,0.688}|	

---Zaptyanie pomocnicze   nr 2

---procent miast z edukacja wysza niz belchor 

	 select
percentile_disc(array[0.1, 0.25,  0.5, 0.75, 0.9]) within group (order by education_bachelor_or_higher) as
KWanil_01_025_05_075_09
from counties c 

----kwanil_01_025__05_075_09      |
--------------------------|
----{11.1,13.7,17.7,23.8,31.8}|

 		---	czy poziom edukacji  ma wpyw na wybor D Trumpa   _badanie dla poziom percentylu glosw 0.9 
  				
  --zapytania glowne
  
  	select count(1)  as liczba_miast, (select count(1) ogolna_liczba_miast from primary_results  
  											LEFT  join counties  on primary_results.fips = counties .fips   
  																where	candidate ilike 'Donald%' 
  																and education_bachelor_or_higher > 
  																( select percentile_disc( 0.9) within group (order by education_bachelor_or_higher)
  										from counties)) , candidate as Precentyl_glowsow_09_dla_kandydata,
  										( select percentile_disc( 0.9) within group (order by education_bachelor_or_higher) as poziom_edukacji_proc
  										from counties) 
  		
  	from primary_results  
  	LEFT join counties  on primary_results.fips = counties .fips   
  	where	candidate ilike 'Donald%' 
  				and education_bachelor_or_higher > ( select percentile_disc( 0.9) within group (order by education_bachelor_or_higher)
  													from counties) 
  				and fraction_votes >( select percentile_disc( 0.9) within group (order by fraction_votes ) 
  									from primary_results  where candidate ilike 'Donald%' ) 
				
  				and county is not null	
  				group by candidate
   	union 
   	select count(1)  as liczba_miast, (select count(1) ogolna_liczba_miast from primary_results  
  											LEFT  join counties  on primary_results.fips = counties .fips   
  																where	candidate ilike 'Donald%' 
  																and education_bachelor_or_higher <
  																( select percentile_disc( 0.1) within group (order by education_bachelor_or_higher)
  										from counties)) , candidate as Precentyl_glowsow_09_dla_kandydata,
  										( select percentile_disc( 0.1) within group (order by education_bachelor_or_higher) as poziom_edukacji
  										
  													from counties) 
  	from primary_results  
  	LEFT join counties  on primary_results.fips = counties .fips   
  	where	candidate ilike 'Donald%' 
  				and education_bachelor_or_higher <( select percentile_disc( 0.1) within group (order by education_bachelor_or_higher)
  													from counties) 
  				and fraction_votes >( select percentile_disc( 0.9) within group (order by fraction_votes ) 
  									from primary_results  where candidate ilike 'Donald%' ) 
				
  				and county is not null	
  				group by candidate
   	union
  	select count(1)  as liczba_miast, (select count(1) ogolna_liczba_miast from primary_results  
  											LEFT  join counties  on primary_results.fips = counties .fips   
  																where	candidate ilike 'Donald%' 
  																and education_bachelor_or_higher > 
  																( select percentile_disc( 0.5) within group (order by education_bachelor_or_higher)
  										from counties)) , candidate as Precentyl_glowsow_09_dla_kandydata,
  										( select percentile_disc( 0.5) within group (order by education_bachelor_or_higher) as poziom_edukacji
  										
  													from counties) 
  	
  													
  	from primary_results  
  	LEFT join counties  on primary_results.fips = counties .fips   
  	where	candidate ilike 'Donald%' 
  				and education_bachelor_or_higher > ( select percentile_disc( 0.5) within group (order by education_bachelor_or_higher)
  													from counties) 
  				and fraction_votes >( select percentile_disc( 0.9) within group (order by fraction_votes ) 
  									from primary_results  where candidate ilike 'Donald%' ) 
				
  				and county is not null	
  				group by candidate
   	union 
   	select count(1)  as liczba_miast, (select count(1) ogolna_liczba_miast from primary_results  
  											LEFT  join counties  on primary_results.fips = counties .fips   
  																where	candidate ilike 'Donald%' 
  																and education_bachelor_or_higher <
  																( select percentile_disc( 0.5) within group (order by education_bachelor_or_higher)
  										from counties)) , candidate as Precentyl_glowsow_09_dla_kandydata,
  										( select percentile_disc( 0.5) within group (order by education_bachelor_or_higher) as poziom_edukacji_proc
  										
  													from counties) 
  	
  													
  	from primary_results  
  	LEFT join counties  on primary_results.fips = counties .fips   
  	where	candidate ilike 'Donald%' 
  				and education_bachelor_or_higher <( select percentile_disc( 0.5) within group (order by education_bachelor_or_higher)
  													from counties) 
  				and fraction_votes >( select percentile_disc( 0.9) within group (order by fraction_votes ) 
  									from primary_results  where candidate ilike 'Donald%' ) 
				
  				and county is not null	
  				group by candidate

  --	koniec zapytania nr 2
  ----   wynik  
   	
 liczba_miast|ogolna_liczba_miast|precentyl_glowsow_09_dla_kandydata|poziom_edukacji_proc
------------|-------------------|----------------------------------|---------------|
         135|               1480|Donald Trump                      |           17.7|
         189|               1220|Donald Trump                      |           17.7|
          22|                295|Donald Trump                      |           11.1|
          34|                224|Donald Trump                      |           31.8|
   	
   	---  wniosek  _kandydat byl wybierany chetniej przez osoby z wyzszym poziomem wyksztalcenia  
   	
   	
   		Zapytanie nr 3
   	
   --- Czy rasa ma wplyw na wybor kandydata w przypadku D J Trumpa  Badanie ze wzgledu na kolor skory czarny. dla precentytli 0.5 i 0.75 
   	
   	 --kwantyle glowso na D J TRUMPA
  	kwanile_glosow_01_025_05_075_09                                         |
------------------------------------------------------------------------|
{0.27899999999999997,0.35200000000000004,0.455,0.5579999999999999,0.688}|	

 select
percentile_disc(array[0.1, 0.25,  0.5, 0.75, 0.9]) within group (order by black ) as
KWanil_01_025_05_075_09
from counties c 

wynik

kwanil_01_025_05_075_09|
-----------------------|
{0.4,0.8,2.4,11.0,30.3}|


---	zapytanie glowne 3.  


select count(1)  as liczba_miast, (select count(1) ogolna_liczba_miast from primary_results  
  												RIGHT join counties  on primary_results.fips = counties .fips   
  																where	candidate ilike 'Donald%' 
  																and black > ( select percentile_disc( 0.9) within group (order by black)
  										from counties)) , candidate as Precentyl_glowsow_05_dla_kandydata,
  										( select percentile_disc( 0.9) within group (order by black) as ilosc_czarnoskorych_proc
  										
  													from counties)   													
  	from primary_results  
  	RIGHT join counties  on primary_results.fips = counties .fips   
  	where	candidate ilike 'Donald%' 
  				and black > ( select percentile_disc( 0.9) within group (order by black)
  													from counties) 
  				and fraction_votes >( select percentile_disc( 0.5) within group (order by fraction_votes ) 
  									from primary_results  where candidate ilike 'Donald%' ) 
				
  				and county is not null	
  				group by candidate
   	union 
   	select count(1)  as liczba_miast, (select count(1) ogolna_liczba_miast from primary_results  
  											LEFT  join counties  on primary_results.fips = counties .fips   
  																where	candidate ilike 'Donald%' 
  																and black <( select percentile_disc( 0.1) within group (order by black)
  										from counties)) , candidate as Precentyl_glowsow_075_dla_kandydata,
  										( select percentile_disc( 0.1) within group (order by black) as ilosc_czarnoskorych_proc
  										
  													from counties) 
  													
  	from primary_results  
  	LEFT join counties  on primary_results.fips = counties .fips   
  	where	candidate ilike 'Donald%' 
  				and black < ( select percentile_disc( 0.1) within group (order by black)
  													from counties) 
  				and fraction_votes >( select percentile_disc( 0.5) within group (order by fraction_votes ) 
  									from primary_results  where candidate ilike 'Donald%' ) 
				
  				and county is not null	
  				group by candidate
  union 
select count(1)  as liczba_miast, (select count(1) ogolna_liczba_miast from primary_results  
  											LEFT  join counties  on primary_results.fips = counties .fips   
  																where	candidate ilike 'Donald%' 
  																and black > ( select percentile_disc( 0.75) within group (order by black)
  										from counties)) , candidate as Precentyl_glowsow_05_dla_kandydata,
  										( select percentile_disc( 0.75) within group (order by black) as ilosc_czarnoskorych
  										
  													from counties)   													
  	from primary_results  
  	LEFT join counties  on primary_results.fips = counties .fips   
  	where	candidate ilike 'Donald%' 
  				and	black > ( select percentile_disc( 0.75) within group (order by black)
  													from counties) 
  				and fraction_votes >( select percentile_disc( 0.5) within group (order by fraction_votes ) 
  									from primary_results  where candidate ilike 'Donald%' ) 
				
  				and county is not null	
  				group by candidate
    union  					
  	select count(1)  as liczba_miast, (select count(1) ogolna_liczba_miast from primary_results  
  											LEFT  join counties  on primary_results.fips = counties .fips   
  																where	candidate ilike 'Donald%' 
  																and black <( select percentile_disc( 0.25)	within group (order by black)
  										from counties)) , candidate as Precentyl_glowsow_05_dla_kandydata,
  										( select percentile_disc( 0.25) within group (order by black) as ilosc_czarnoskorych
  										
  													from counties)   													
  	from primary_results  
  	LEFT join counties  on primary_results.fips = counties .fips   
  	where	candidate ilike 'Donald%' 
  				and	black < ( select percentile_disc( 0.25) within group (order by black)
  													from counties) 
  				and fraction_votes <( select percentile_disc( 0.5) within group (order by fraction_votes ) 
  									from primary_results  where candidate ilike 'Donald%' ) 
				
  				and county is not null	
  				group by candidate												
  union 
   select count(1)  as liczba_miast, (select count(1) ogolna_liczba_miast from primary_results  
  											LEFT  join counties  on primary_results.fips = counties .fips   
  																where	candidate ilike 'Donald%' 
  																and black > ( select percentile_disc( 0.5) within group (order by black)
  										from counties)) , candidate as Precentyl_glowsow_05_dla_kandydata,
  										( select percentile_disc( 0.5) within group (order by black) as ilosc_czarnoskorych
  										
  													from counties)   													
  	from primary_results  
  	LEFT join counties  on primary_results.fips = counties .fips   
  	where	candidate ilike 'Donald%' 
  				and	black > ( select percentile_disc( 0.5) within group (order by black)
  													from counties) 
  				and fraction_votes >( select percentile_disc( 0.5) within group (order by fraction_votes ) 
  									from primary_results  where candidate ilike 'Donald%' ) 
				
  				and county is not null	
  				group by candidate
    union  					
  	select count(1)  as liczba_miast, (select count(1) ogolna_liczba_miast from primary_results  
  											LEFT  join counties  on primary_results.fips = counties .fips   
  																where	candidate ilike 'Donald%' 
  																and black <( select percentile_disc( 0.5) within group (order by black)
  										from counties)) , candidate as Precentyl_glowsow_05_dla_kandydata,
  										( select percentile_disc( 0.5) within group (order by black) as ilosc_czarnoskorych
  										
  													from counties)   													
  	from primary_results  
  	LEFT join counties  on primary_results.fips = counties .fips   
  	where	candidate ilike 'Donald%' 
  				and	black > ( select percentile_disc( 0.5) within group (order by black)
  													from counties) 
  				and fraction_votes <( select percentile_disc( 0.5) within group (order by fraction_votes ) 
  									from primary_results  where candidate ilike 'Donald%' ) 
				
  				and county is not null	
  				group by candidate			
   	
   	
   ---wynik  
   
  			liczba_miast|ogolna_liczba_miast|precentyl_glowsow_05_dla_kandydata|ilosc_czarnoskorych_proc
------------|-------------------|----------------------------------|------------------------
         110|                146|Donald Trump                      |                     0.4
         811|               1225|Donald Trump                      |                     2.4
         356|                762|Donald Trump                      |                    11.0
         176|                311|Donald Trump                      |                    30.3
         224|                599|Donald Trump                      |                     0.8
         647|               1461|Donald Trump                      |                     2.4	
   	
   	
   	
   	
   	
   	
   	
   	
   	
   	
  	
  	
  ------------Reublikanie- DEmokraci    
  
  	select count(fips) from counties;
  
  		select count(fips) from primary_results pr ;
  
  	
  	
  	
  	