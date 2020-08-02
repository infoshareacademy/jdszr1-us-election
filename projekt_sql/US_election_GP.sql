
 
  
 
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
   	
   	
  
   	
   	Zadanie nr 2   	
   	
  	
  	
  ------------Reublikanie- DEmokraci  analiza ze wzgledu na liczbe ludnosi i wiek
  
  	select * from counties;
  
  		select * from primary_results pr ;
  	
  ---  analiza z uwagi na wielkoc miejscowoci(liczba ludnosci w okregach)
  	
 
  
---Analiza dla okregow o duzej liczebnosci (perc0.9)



  	select count(1)  as liczba_miast, (select count(1) ogolna_liczba_miast from primary_results  
  											LEFT  join counties  on primary_results.fips = counties .fips   
  																where	party ilike 'Dem%'
  																--and		state_abbreviation  is not NULL
  																and	population > ( select percentile_disc( 0.9) within group (order by population)
  																from counties)),																
  																 party as Precentyl_glowsow_05_dla_partii,
  															( select percentile_disc( 0.9) within group (order by population) as perc_pop	from counties)   
													
  	from primary_results  
  	LEFT join counties  on primary_results.fips = counties .fips   
  	where	party ilike 'Dem%'
  				--and		state_abbreviation  is not NULL
  				and	population > ( select percentile_disc( 0.9) within group (order by population)
  													from counties) 
  				and fraction_votes >( select percentile_disc( 0.5) within group (order by fraction_votes ) 
  									from primary_results where	party ilike 'Dem%' ) 
				
  				group by party
  	union 
  	select count(1)  as liczba_miast, (select count(1) ogolna_liczba_miast from primary_results  
  											LEFT  join counties  on primary_results.fips = counties .fips   
  																where	party ilike 'Rep%'
  																
  																and	population >( select percentile_disc( 0.9) within group (order by population)
  																from counties)),																
  																 party as Precentyl_glowsow_05_dla_partii,
  															( select percentile_disc( 0.9) within group (order by population) as perc_pop	from counties)   
													
  	from primary_results  
  	LEFT join counties  on primary_results.fips = counties .fips   
  	where	party ilike 'Rep%'
  				and	population >( select percentile_disc( 0.9) within group (order by population)
  													from counties) 
  				and fraction_votes >( select percentile_disc( 0.5) within group (order by fraction_votes ) 
  									from primary_results where	party ilike 'Rep%' ) 
				
  				group by party
  
 
  		liczba_miast|ogolna_liczba_miast|precentyl_glowsow_05_dla_partii|perc_pop|
------------|-------------------|-------------------------------|--------|
         527|                883|Republican                     |  245829|
         268|                484|Democrat                       |  245829|		
  				
  					
  ----Analiza dla okregow o duzej liczebnosci (perc0.9)  gdzie bardzo chetnie oddawano glosy na kandydata z jednej partii
  
  
         select count(1)  as liczba_miast, (select count(1) ogolna_liczba_miast from primary_results  
  											LEFT  join counties  on primary_results.fips = counties .fips   
  																where	party ilike 'Dem%'
  																--and		state_abbreviation  is not NULL
  																and	population > ( select percentile_disc( 0.9) within group (order by population)
  																from counties)),																
  																 party as Precentyl_glowsow_05_dla_partii,
  															( select percentile_disc( 0.9) within group (order by population) as perc_pop	from counties)   
													
  	from primary_results  
  	LEFT join counties  on primary_results.fips = counties .fips   
  	where	party ilike 'Dem%'
  				--and		state_abbreviation  is not NULL
  				and	population > ( select percentile_disc( 0.9) within group (order by population)
  													from counties) 
  				and fraction_votes >( select percentile_disc( 0.9) within group (order by fraction_votes ) 
  									from primary_results where	party ilike 'Dem%' ) 
				
  				group by party
  	union 
  	select count(1)  as liczba_miast, (select count(1) ogolna_liczba_miast from primary_results  
  											LEFT  join counties  on primary_results.fips = counties .fips   
  																where	party ilike 'Rep%'
  																
  																and	population >( select percentile_disc( 0.9) within group (order by population)
  																from counties)),																
  																 party as Precentyl_glowsow_05_dla_partii,
  															( select percentile_disc( 0.9) within group (order by population) as perc_pop	from counties)   
													
  	from primary_results  
  	LEFT join counties  on primary_results.fips = counties .fips   
  	where	party ilike 'Rep%'
  				and	population >( select percentile_disc( 0.9) within group (order by population)
  													from counties) 
  				and fraction_votes >( select percentile_disc( 0.9) within group (order by fraction_votes ) 
  									from primary_results where	party ilike 'Rep%' ) 
				
  				group by party
    --Wynik
         
  	liczba_miast|ogolna_liczba_miast|precentyl_glowsow_05_dla_partii|perc_pop|
------------|-------------------|-------------------------------|--------|
         104|                883|Republican                     |  245829|
          22|                484|Democrat                       |  245829|			
  	
      --  W wiekszych okregach popularnoscia cieszyli sie republikanie 
      
        -- jak wyglada rozkad glosow w  malych okregach  (glosow wiecej niz mediana)
      
        select count(1)  as liczba_miast, (select count(1) ogolna_liczba_miast from primary_results  
  											LEFT  join counties  on primary_results.fips = counties .fips   
  																where	party ilike 'Dem%'
  																--and		state_abbreviation  is not NULL
  																and	population < ( select percentile_disc( 0.1) within group (order by population)
  																from counties)),																
  																 party as Precentyl_glowsow_05_dla_partii,
  															( select percentile_disc( 0.1) within group (order by population) as perc_pop	from counties)   
													
  	from primary_results  
  	LEFT join counties  on primary_results.fips = counties .fips   
  	where	party ilike 'Dem%'
  				--and		state_abbreviation  is not NULL
  				and	population <( select percentile_disc( 0.1) within group (order by population)
  													from counties) 
  				and fraction_votes >( select percentile_disc( 0.5) within group (order by fraction_votes ) 
  									from primary_results where	party ilike 'Dem%' ) 
				
  				group by party
  	union 
  	select count(1)  as liczba_miast, (select count(1) ogolna_liczba_miast from primary_results  
  											LEFT  join counties  on primary_results.fips = counties .fips   
  																where	party ilike 'Rep%'
  																
  																and	population <( select percentile_disc( 0.1) within group (order by population)
  																from counties)),																
  																 party as Precentyl_glowsow_05_dla_partii,
  															( select percentile_disc( 0.1) within group (order by population) as perc_pop	from counties)   
													
  	from primary_results  
  	LEFT join counties  on primary_results.fips = counties .fips   
  	where	party ilike 'Rep%'
  				and	population <( select percentile_disc( 0.1) within group (order by population)
  													from counties) 
  				and fraction_votes >( select percentile_disc( 0.5) within group (order by fraction_votes ) 
  									from primary_results where	party ilike 'Rep%' ) 
				
  				group by party  
  				
  liczba_miast|ogolna_liczba_miast|precentyl_glowsow_05_dla_partii|perc_pop|
------------|-------------------|-------------------------------|--------|
         238|                470|Democrat                       |    5202|
         382|                841|Republican                     |    5202|
         
         
         
  				
  				
  				
       -- jak wyglada rozkad glosow w  malych okregach  z wyrazna tendencja dla 1 z partii 
          
       select count(1)  as liczba_miast, (select count(1) ogolna_liczba_miast from primary_results  
  											LEFT  join counties  on primary_results.fips = counties .fips   
  																where	party ilike 'Dem%'
  																--and		state_abbreviation  is not NULL
  																and	population < ( select percentile_disc( 0.1) within group (order by population)
  																from counties)),																
  																 party as Precentyl_glowsow_05_dla_partii,
  															( select percentile_disc( 0.1) within group (order by population) as perc_pop	from counties)   
													
  	from primary_results  
  	LEFT join counties  on primary_results.fips = counties .fips   
  	where	party ilike 'Dem%'
  				--and		state_abbreviation  is not NULL
  				and	population <( select percentile_disc( 0.1) within group (order by population)
  													from counties) 
  				and fraction_votes >( select percentile_disc( 0.9) within group (order by fraction_votes ) 
  									from primary_results where	party ilike 'Dem%' ) 
				
  				group by party
  	union 
  	select count(1)  as liczba_miast, (select count(1) ogolna_liczba_miast from primary_results  
  											LEFT  join counties  on primary_results.fips = counties .fips   
  																where	party ilike 'Rep%'
  																
  																and	population <( select percentile_disc( 0.1) within group (order by population)
  																from counties)),																
  																 party as Precentyl_glowsow_05_dla_partii,
  															( select percentile_disc( 0.1) within group (order by population) as perc_pop	from counties)   
													
  	from primary_results  
  	LEFT join counties  on primary_results.fips = counties .fips   
  	where	party ilike 'Rep%'
  				and	population <( select percentile_disc( 0.1) within group (order by population)
  													from counties) 
  				and fraction_votes >( select percentile_disc( 0.9) within group (order by fraction_votes ) 
  									from primary_results where	party ilike 'Rep%' ) 
				
  				group by party  
  	--wynik
  				
  	liczba_miast|ogolna_liczba_miast|precentyl_glowsow_05_dla_partii|perc_pop|
------------|-------------------|-------------------------------|--------|
         153|                841|Republican                     |    5202|
          27|                470|Democrat                       |    5202|	
          
          
    ---Wniosek  male okregi cieszyly sie bardzej wsrod democratow  jednak  jesli juz jakis okrag jest bardziej przychylny republikanom to oddaje \
    ---- to liczba glosw jest b duza .  
    
          
       ------alaniza z uwagi na wiek_ age_over65
   -wyliczenie percentyli
      select
percentile_disc(array[0.1, 0.25,  0.5, 0.75, 0.9]) within group (order by age_over65 ) as
KWanil_01_025_05_075_09
from counties c     
          
     kwanil_01_025_05_075_09   |
--------------------------|
{12.2,14.7,17.2,19.8,23.5}|  

-- analiza wg dwoch skrajnych percentyli dla wieku powyzej  65_lat   


select count(1)  as liczba_miast, (select count(1) ogolna_liczba_miast from primary_results  
  											LEFT  join counties  on primary_results.fips = counties .fips   
  																where	party ilike 'Dem%'
  																--and		state_abbreviation  is not NULL
  																and	age_over65  < ( select percentile_disc( 0.1) within group (order by age_over65 )
  																from counties)),																
  																 party as Precentyl_glowsow_05_dla_partii,
  															( select percentile_disc( 0.1) within group (order by age_over65 ) as perc_age	from counties)   
													
  	from primary_results  
  	LEFT join counties  on primary_results.fips = counties .fips   
  	where	party ilike 'Dem%'
  				--and		state_abbreviation  is not NULL
  				and	age_over65 <( select percentile_disc( 0.1) within group (order by age_over65)
  													from counties) 
  				and fraction_votes >( select percentile_disc( 0.9) within group (order by fraction_votes ) 
  									from primary_results where	party ilike 'Dem%' ) 
				
  				group by party
  	union 
  	select count(1)  as liczba_miast, (select count(1) ogolna_liczba_miast from primary_results  
  											LEFT  join counties  on primary_results.fips = counties .fips   
  																where	party ilike 'Rep%'
  																--and		state_abbreviation  is not NULL
  																and	age_over65 <( select percentile_disc( 0.1) within group (order by age_over65)
  																from counties)),																
  																 party as Precentyl_glowsow_dla_partii,
  															( select percentile_disc( 0.1) within group (order by age_over65) as perc_age	from counties)   
													
  	from primary_results  
  	LEFT join counties  on primary_results.fips = counties .fips   
  	where	party ilike 'Rep%'
  				and	age_over65 <( select percentile_disc( 0.1) within group (order by age_over65)
  													from counties) 
  				and fraction_votes >( select percentile_disc( 0.9) within group (order by fraction_votes ) 
  									from primary_results where	party ilike 'Rep%' ) 
				
				group by party
      
				
		Wynik			dla peercentyla glosow 05 
       liczba_miast|ogolna_liczba_miast|precentyl_glowsow__dla_partii|perc_age|
------------|-------------------|-------------------------------|--------|
         563|               1044|Republican                     |    12.2|
         271|                526|Democrat                       |    12.2|
   
      Wynik			dla peercentyla glosow 09
      
      liczba_miast|ogolna_liczba_miast|precentyl_glowsow_05_dla_partii|perc_age|
------------|-------------------|-------------------------------|--------|
          48|                526|Democrat                       |    12.2|
          87|               1044|Republican                     |    12.2|
         
     --- wniosek  dla okrgow  "mlodych"  glosy rozkladaja sie po rowno
     
          
      
       select count(1)  as liczba_miast, (select count(1) ogolna_liczba_miast from primary_results  
  											LEFT  join counties  on primary_results.fips = counties .fips   
  																where	party ilike 'Dem%'
  																--and		state_abbreviation  is not NULL
  																and	age_over65  > ( select percentile_disc( 0.9) within group (order by age_over65 )
  																from counties)),																
  																 party as Precentyl_glowsow_05_dla_partii,
  															( select percentile_disc( 0.9) within group (order by age_over65 ) as perc_age	from counties)   
													
  	from primary_results  
  	LEFT join counties  on primary_results.fips = counties .fips   
  	where	party ilike 'Dem%'
  				--and		state_abbreviation  is not NULL
  				and	age_over65 >( select percentile_disc( 0.9) within group (order by age_over65)
  													from counties) 
  				and fraction_votes >( select percentile_disc( 0.5) within group (order by fraction_votes ) 
  									from primary_results where	party ilike 'Dem%' ) 
				
  				group by party
  	union 
  	select count(1)  as liczba_miast, (select count(1) ogolna_liczba_miast from primary_results  
  											LEFT  join counties  on primary_results.fips = counties .fips   
  																where	party ilike 'Rep%'
  																--and		state_abbreviation  is not NULL
  																and	age_over65 >( select percentile_disc( 0.9) within group (order by age_over65)
  																from counties)),																
  																 party as Precentyl_glowsow_05_dla_partii,
  															( select percentile_disc( 0.9) within group (order by age_over65) as perc_age	from counties)   
													
  	from primary_results  
  	LEFT join counties  on primary_results.fips = counties .fips   
  	where	party ilike 'Rep%'
  				and	age_over65 >( select percentile_disc( 0.9) within group (order by age_over65)
  													from counties) 
  				and fraction_votes >( select percentile_disc( 0.5) within group (order by fraction_votes ) 
  									from primary_results where	party ilike 'Rep%' ) 
				
				group by party   
          
     dla miast ze srednia wieku dla perc 0.9  glosy perc 0.9
          
    liczba_miast|ogolna_liczba_miast|precentyl_glowsow_05_dla_partii|perc_age|
------------|-------------------|-------------------------------|--------|
          17|                548|Democrat                       |    23.5|
         148|               1043|Republican                     |    23.5|   
         
   dla miast ze srednia wieku dla perc 0.9  glosy perc 0.5
         
  liczba_miast|ogolna_liczba_miast|precentyl_glowsow_05_dla_partii|perc_age|
------------|-------------------|-------------------------------|--------|
         511|               1043|Republican                     |    23.5|
         289|                548|Democrat                       |    23.5|       
         
 ---- Misata  ze spolecznoscie  w starszym wieku  lekko przychylaja   sie do demokratow  
 	---natomiast spora czesc miast gdzie dominuja przkonania dla republikanow bardzo duzy odsetek ludnosci na nich glosowal
 
         
  	
