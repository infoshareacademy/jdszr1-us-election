-- najwiêkszy odsetek g³osów Missisipi, Alabama, South Carolina, Virginia, Georgia, Alabama, Tennessee, 
select state, county, votes, fraction_votes from primary_results pr 
where candidate ilike '%Clinton' 
group by 1, 2, 3 , 4
order by 4 desc 

--Najwieksza liczba glosow California, Floryda, New York, Illinois, Texas
select state, sum(votes) as liczba_glosow from primary_results pr 
where candidate ilike '%Clinton'
group by 1
order by 2 desc 

--Najmniejsza liczba glosow Alaska, North Dakota, Wyoming, Maine, Idaho
select state, sum(votes) as liczba_glosow from primary_results pr 
where candidate ilike '%Clinton'
group by 1
order by 2  

-- Suma glosow calkowita Hilary w USA
select sum(votes) as liczba_calkowita_glosow from primary_results pr 
where candidate ilike '%Clinton' -- 15 692 452 glosy

--liczba glosow ca³kowita w USA
select sum(votes) from primary_results pr --56 759 187 glosy

--ilosc miast z P25, P50 , P75
select percentile_disc(0.25) within group (order by fraction_votes ) from primary_results pr 
where candidate ilike '%Clinton' -- 0.356

select count(county) from primary_results pr 
where candidate ilike '%Clinton' and fraction_votes < 0.356 --1 046 miast, gdzie jej udzial by³ <25%

select percentile_disc(0.50) within group (order by fraction_votes ) from primary_results pr 
where candidate ilike '%Clinton' -- 0.47

select count(county) from primary_results pr 
where candidate ilike '%Clinton' and fraction_votes < 0.47 and fraction_votes >= 0.356 --1 055 miast, gdzie jej udzial by³ >25% i <50%

select percentile_disc(0.75) within group (order by fraction_votes ) from primary_results pr 
where candidate ilike '%Clinton' -- 0.577

select count(county) from primary_results pr 
where candidate ilike '%Clinton' and fraction_votes < 0.577 and fraction_votes >= 0.47 --1 049 miast, gdzie jej udzial by³ >50% i <75%

select count(county) from primary_results pr 
where candidate ilike '%Clinton' and fraction_votes >= 0.577  --1 055 miast, gdzie jej udzial by³ >75%

--stany, w ktorych procentowo miala najwiêkszy udzial w glosach Nebraska, Maine, Missipi, Alabama, Georgia
select state , max(fraction_votes) from primary_results pr 
where candidate ilike '%Clinton' 
group by 1
order by 2 desc

-- zebranie danych demograficznych z podzia³em na 51 stanow
select * from counties c 
where state_abbreviation = '' and fips > 0
order by area_name  

-- zebranie danych demograficznych ca³kowitych dla USA
select * from counties c 
where state_abbreviation = '' and fips < 1
order by area_name  
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
--Wnioski po analize powy¿szych tabel - porównianie 51 stanów do wartoœci USA global.

--1.Analiza stanow, gdzie liczba osob >65 roku zycna jest powy¿ej œredniej w USA 14.5

--stany w ktorych jest najwiecej osob >65 i udzial w glosach Hilary >75% i c.age_over65>14.5 (srednia dla calych usa)
select c.area_name , c.age_over65,sum(p.votes)  from counties c 
join primary_results as p on c.area_name =p.state 
where c.state_abbreviation = '' and c.fips > 0 and p.candidate ilike '%Clinton' and fraction_votes >0.577 and c.age_over65 >14.5
group by 1,2
order by 3 desc
--suma glosow dla w/w przypadku - 4 474 511 glosow
select sum(p.votes)  from counties c 
join primary_results as p on c.area_name =p.state 
where c.state_abbreviation = '' and c.fips > 0 and p.candidate ilike '%Clinton' and fraction_votes >0.577 and c.age_over65 >14.5

--stany w ktorych jest najwiecej osob >65 i udzial w glosach Hilary <25% i c.age_over65>14.5 (srednia dla calych usa)
select c.area_name , c.age_over65, sum(p.votes) from counties c 
join primary_results as p on c.area_name =p.state 
where c.state_abbreviation = '' and c.fips > 0 and p.candidate ilike '%Clinton' and fraction_votes <0.356 and c.age_over65 <14.5
group by 1,2
order by 3 desc
--suma glosow dla w/w przypadku - 72 830 glosow
select sum(p.votes)  from counties c 
join primary_results as p on c.area_name =p.state 
where c.state_abbreviation = '' and c.fips > 0 and p.candidate ilike '%Clinton' and fraction_votes <0.356 and c.age_over65>14.5

--2.Analiza stanow, gdzie liczba kobiet jest powy¿ej sredniej w USA 50.8

--stany w ktorych jest najwiecej kobiet i udzial w glosach Hilary >75% i female>50.8 (srednia dla calych usa)
select c.area_name , c.female,sum(p.votes)  from counties c 
join primary_results as p on c.area_name =p.state 
where c.state_abbreviation = '' and c.fips > 0 and p.candidate ilike '%Clinton' and fraction_votes >0.577 and c.female >50.8
group by 1,2
order by 3 desc
--suma glosow dla w/w przypadku - 5 636 382 glosy
select sum(p.votes)  from counties c 
join primary_results as p on c.area_name =p.state 
where c.state_abbreviation = '' and c.fips > 0 and p.candidate ilike '%Clinton' and fraction_votes >0.577 and c.female >50.8

--stany w ktorych jest najmniej kobiet i udzial w glosach Hilary <25% i female<50.8 (srednia dla calych usa)
select c.area_name , c.female,sum(p.votes)  from counties c 
join primary_results as p on c.area_name =p.state 
where c.state_abbreviation = '' and c.fips > 0 and p.candidate ilike '%Clinton' and fraction_votes <0.356 and c.female <50.8
group by 1,2
order by 3 desc
--suma glosow dla w/w przypadku - 158 564 glosy
select sum(p.votes)  from counties c 
join primary_results as p on c.area_name =p.state 
where c.state_abbreviation = '' and c.fips > 0 and p.candidate ilike '%Clinton' and fraction_votes <0.356 and c.female <50.8

--3.Analiza stanow, gdzie liczba czarnoskórej ludnoœci jest powy¿ej sredniej w USA 13.2

--stany w ktorych jest najwiecej czarnoskórych i udzial w glosach Hilary >75% i female>50.8 (srednia dla calych usa)
select c.area_name , c.black,sum(p.votes)  from counties c 
join primary_results as p on c.area_name =p.state 
where c.state_abbreviation = '' and c.fips > 0 and p.candidate ilike '%Clinton' and fraction_votes >0.577 and c.black >13.2
group by 1,2
order by 3 desc
--suma glosow dla w/w przypadku - 5 338 592 glosy
select sum(p.votes)  from counties c 
join primary_results as p on c.area_name =p.state 
where c.state_abbreviation = '' and c.fips > 0 and p.candidate ilike '%Clinton' and fraction_votes >0.577 and c.black >13.2

--stany w ktorych jest najmniej czanoskórych osób i udzial w glosach Hilary <25% i black<13.2 (srednia dla calych usa)
select c.area_name , c.black,sum(p.votes)  from counties c 
join primary_results as p on c.area_name =p.state 
where c.state_abbreviation = '' and c.fips > 0 and p.candidate ilike '%Clinton' and fraction_votes <0.356 and c.black <13.2
group by 1,2
order by 3 desc
--suma glosow dla w/w przypadku - 200 715 glosy
select sum(p.votes)  from counties c 
join primary_results as p on c.area_name =p.state 
where c.state_abbreviation = '' and c.fips > 0 and p.candidate ilike '%Clinton' and fraction_votes <0.356 and c.black <13.2

--4.Analiza stanow, gdzie liczba latynoskiej ludnoœci jest powy¿ej sredniej w USA 17

--stany w ktorych jest najwiecej latynoskiej i udzial w glosach Hilary >75% i latino>17 (srednia dla calych usa)
select c.area_name , c.hispanic_latino ,sum(p.votes)  from counties c 
join primary_results as p on c.area_name =p.state 
where c.state_abbreviation = '' and c.fips > 0 and p.candidate ilike '%Clinton' and fraction_votes >0.577 and c.hispanic_latino >17
group by 1,2
order by 3 desc
--suma glosow dla w/w przypadku - 3 559 291 glosow
select sum(p.votes)  from counties c 
join primary_results as p on c.area_name =p.state 
where c.state_abbreviation = '' and c.fips > 0 and p.candidate ilike '%Clinton' and fraction_votes >0.577 and c.hispanic_latino >17.0

--stany w ktorych jest najmniej latynoskich osób i udzial w glosach Hilary <25% i latino<17 (srednia dla calych usa)
select c.area_name , c.hispanic_latino ,sum(p.votes)  from counties c 
join primary_results as p on c.area_name =p.state 
where c.state_abbreviation = '' and c.fips > 0 and p.candidate ilike '%Clinton' and fraction_votes <0.356 and c.hispanic_latino <17
group by 1,2
order by 3 desc
--suma glosow dla w/w przypadku - 248 385 glosy
select sum(p.votes)  from counties c 
join primary_results as p on c.area_name =p.state 
where c.state_abbreviation = '' and c.fips > 0 and p.candidate ilike '%Clinton' and fraction_votes <0.356 and c.hispanic_latino <17


--5.Analiza stanow, gdzie liczba obcojezycznej ludnoœci jest powy¿ej sredniej w USA 21

--stany w ktorych jest najwiecej naplywowej ludnosci i udzial w glosach Hilary >75% i foreign born>21 (srednia dla calych usa)
select c.area_name , c.foreign_born ,sum(p.votes)  from counties c 
join primary_results as p on c.area_name =p.state 
where c.state_abbreviation = '' and c.fips > 0 and p.candidate ilike '%Clinton' and fraction_votes >0.577 and c.foreign_born >21
group by 1,2
order by 3 desc
--suma glosow dla w/w przypadku - 1 610 908 glosow
select sum(p.votes)  from counties c 
join primary_results as p on c.area_name =p.state 
where c.state_abbreviation = '' and c.fips > 0 and p.candidate ilike '%Clinton' and fraction_votes >0.577 and c.foreign_born >21.0

--stany w ktorych jest najmniej naplywowej ludnosci i udzial w glosach Hilary <25% i ofreign born<21 (srednia dla calych usa)
select c.area_name , c.foreign_born ,sum(p.votes)  from counties c 
join primary_results as p on c.area_name =p.state 
where c.state_abbreviation = '' and c.fips > 0 and p.candidate ilike '%Clinton' and fraction_votes <0.356 and c.foreign_born <21
group by 1,2
order by 3 desc
--suma glosow dla w/w przypadku - 254 814 glosy
select sum(p.votes)  from counties c 
join primary_results as p on c.area_name =p.state 
where c.state_abbreviation = '' and c.fips > 0 and p.candidate ilike '%Clinton' and fraction_votes <0.356 and c.foreign_born <21

--6.Analiza stanow, gdzie liczba wyksztalconej ludnoœci  jest powy¿ej sredniej w USA 86

--stany w ktorych jest najwiecej wyksztalconej ludnosci i udzial w glosach Hilary >75% i education_highschool>86 (srednia dla calych usa)
select c.area_name , c.education_highschool_or_higher ,sum(p.votes)  from counties c 
join primary_results as p on c.area_name =p.state 
where c.state_abbreviation = '' and c.fips > 0 and p.candidate ilike '%Clinton' and fraction_votes >0.577 and c.education_highschool_or_higher >86
group by 1,2
order by 3 desc
--suma glosow dla w/w przypadku - 3 339 226 glosow
select sum(p.votes)  from counties c 
join primary_results as p on c.area_name =p.state 
where c.state_abbreviation = '' and c.fips > 0 and p.candidate ilike '%Clinton' and fraction_votes >0.577 and c.education_highschool_or_higher >86.0

--stany w ktorych jest najmniej wykszta³conej ludnosci i udzial w glosach Hilary <25% i education_highschool<86 (srednia dla calych usa)
select c.area_name , c.education_highschool_or_higher ,sum(p.votes)  from counties c 
join primary_results as p on c.area_name =p.state 
where c.state_abbreviation = '' and c.fips > 0 and p.candidate ilike '%Clinton' and fraction_votes <0.356 and c.education_highschool_or_higher <86
group by 1,2
order by 3 desc
--suma glosow dla w/w przypadku - 91 903 glosy
select sum(p.votes)  from counties c 
join primary_results as p on c.area_name =p.state 
where c.state_abbreviation = '' and c.fips > 0 and p.candidate ilike '%Clinton' and fraction_votes <0.356 and c.education_highschool_or_higher <86

--7.Lista stanow,gdzie s¹ spe³nione wszystki powy¿sze warunki - Stan NEW JERSEY
select c.area_name ,p.fraction_votes, sum(p.votes)  from counties c 
join primary_results as p on c.area_name =p.state 
where c.state_abbreviation = '' and c.fips > 0 and p.candidate ilike '%Clinton' --and fraction_votes >0.577 
and c.education_highschool_or_higher >86 -- Analiza 6
and c.foreign_born >21 -- Analiza 5
and c.hispanic_latino >17 -- Analiza 4
and c.black >13.2 -- Analiza 3
and c.female >50.8 -- Analiza 2
and c.age_over65 >14.5 -- Analiza 1
group by 1,2
order by 2 desc 
