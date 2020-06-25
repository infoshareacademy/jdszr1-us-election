-- Stworzenie pomocniczej tabeli ben_carson, zawierającej tylko wybrane dane o wynikach 
-- jedynago czarnoskórego kandydata Bena Carsona oraz statystykach okręgów.

create table ben_carson as (
select 
	pr.candidate,
	pr.fips,
	pr.state,
	pr.county ,
	pr.party,
	pr.votes ,
	pr.fraction_votes ,
	c.population ,
	c.age_over65 ,
	c.female ,
	c.white ,
	c.black ,
	c.not_white ,
	c.foreign_born ,
	c.education_highschool_or_higher ,
	c.education_bachelor_or_higher ,
	c.income_per_capita_12months ,
	c.income_household_median 
from primary_results pr 
join counties c on pr.fips = c.fips 
where pr.candidate = 'Ben Carson' and pr.fips not in (46113, 36085, 36047)
order by pr.fraction_votes desc)

select * from ben_carson bc 

-- Oblieczenie percentyli 10, 75 oraz 90 z rozkładu procentu głosów
select
	percentile_disc(0.10) within group (order by bc.fraction_votes) as q_10,
	percentile_disc(0.75) within group (order by bc.fraction_votes) as q3,
	percentile_disc(0.90) within group (order by bc.fraction_votes) as q_90
from ben_carson bc 

-- Statystyki dla głosów powyżej percentyla 75
select * 
from ben_carson bc 
where fraction_votes > 0.083


-- Statystyki dla całego kraju:
select * from counties c 
where fips = 0
-- age over 65 14.5
-- white 77.4
-- black 13.2
-- not white 22.5
-- education bachelor 28.8
-- income per capita 28155


-- średni dochód dla okręgów gdzie wyniki bena carsona są powyżej 90 percentyla - 
-- jest o prawie 20% niższy niż średnia krajowa
select avg(income_per_capita_12months) from ben_carson bc 
where fraction_votes > (select
	percentile_disc(0.9) within group (order by bc.fraction_votes) as q_90
from ben_carson bc)
-- 22632

with usa_income as (select income_per_capita_12months as usa_income from counties where fips = 0)
select ((avg(income_per_capita_12months ) - usa_income )/usa_income)*100 as income_diff from ben_carson , usa_income
where fraction_votes > (select	
	percentile_disc(0.9) within group (order by fraction_votes) as q_90
	from ben_carson)
group by usa_income
-- -19.61%


-- średni odsetek osób > 65 w okręgach gdzie wyniki bena carsona były wyższe niż 
-- 90 percentyl - o 26% wyższy niż średnia dla USA
select avg(age_over65 ) from ben_carson bc 
where fraction_votes > (select
	percentile_disc(0.9) within group (order by bc.fraction_votes) as q_90
from ben_carson bc)
--18.3

with over65 as (select age_over65 as usa_over65 from counties where fips = 0)
select ((avg(age_over65) - o.usa_over65)/o.usa_over65)*100 as age_over65_diff from ben_carson , over65 o
where fraction_votes > (select	
	percentile_disc(0.9) within group (order by fraction_votes) as q_90
	from ben_carson)
group by o.usa_over65
-- +25.97%


-- średni odsetek not white w okręgach gdzie wyniki bena carsona były wyższe niż 
-- 90 percentyl - o 30% niższy niż średnia dla USA
select avg(not_white) from ben_carson bc 
where fraction_votes > (select
	percentile_disc(0.9) within group (order by bc.fraction_votes) as q_90
from ben_carson bc)
--15.74

with usa_notwhite as (select not_white as usa_notwhite from counties where fips = 0)
select ((avg(not_white ) - usa_notwhite )/usa_notwhite)*100 as not_white_diff from ben_carson , usa_notwhite
where fraction_votes > (select	
	percentile_disc(0.9) within group (order by fraction_votes) as q_90
	from ben_carson)
group by usa_notwhite
-- -30.06%

