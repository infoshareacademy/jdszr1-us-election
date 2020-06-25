
-- Stworzenie pomocniczej tabeli women, zawierającej tylko wybrane dane o wynikach kobiet
-- (Hilary Clinton i Carly Fiorina) oraz statystykach okręgów.
create table women as (
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
where (pr.candidate = 'Hillary Clinton' or pr.candidate = 'Carly Fiorina') and pr.fips not in (46113, 36085, 36047)
order by pr.fraction_votes desc)

select * from women 

-- Oblieczenie percentyli 10, 75 oraz 90 z rozkładu procentu głosów
select
	percentile_disc(0.10) within group (order by w.fraction_votes) as p_10,
	percentile_disc(0.75) within group (order by w.fraction_votes) as q3,
	percentile_disc(0.90) within group (order by w.fraction_votes) as p_90
from women w

-- Statystyki dla głosów powyżej percentyla 75
select *
from women w
where w.fraction_votes > 0.627

-- Statystyki dla całego kraju:
select * from counties c 
where fips = 0
-- age over 65 14.5
-- female 50.8
-- white 77.4
-- black 13.2
-- not white 22.5
-- education bachelor 28.8
-- income per capita 28155


-- średni odsetek głosów oddanych na kobiety w okręgach o odsetku kobiet w populacji
-- powyżej średniej USA - o 15,4% więcej niż średnia
select avg(fraction_votes ) from women w 
where female > (select female from counties c2 where fips = 0)
-- 0.596

with women_votes as (select avg(fraction_votes ) as votes_avg from women w2 )
select ((avg(fraction_votes ) - votes_avg)/votes_avg)*100 as votes_diff from women w, women_votes
where female > (select female from counties c2 where fips = 0)
group by women_votes.votes_avg
-- +15.38%

-- średni odsetek głosów oddanych na kobiety w okręgach o odsetku not_white
-- powyżej średniej USA - o 34%% więcej niż średnia
select avg(fraction_votes ) from women w 
where not_white > 22.5
-- 0.691

with women_votes as (select avg(fraction_votes ) as votes_avg from women w2 )
select ((avg(fraction_votes ) - votes_avg)/votes_avg)*100 as votes_diff from women w, women_votes
where not_white > (select not_white from counties c2 where fips = 0)
group by women_votes.votes_avg
-- +33.95%

-- średni odsetek osób > 65  w okręgach, gdzie wyniki dla kobiet są wyższe niż 90 
-- percentyl - o 14.4% więcej niż średnia dla USA
select avg(age_over65 ) from women w 
where fraction_votes > (select	
	percentile_disc(0.9) within group (order by w.fraction_votes) as q_90
	from women w)
-- 16.6

with over65 as (select age_over65 as usa_over65 from counties where fips = 0)
select ((avg(age_over65) - o.usa_over65)/o.usa_over65)*100 as age_over65_diff from women w2 , over65 o
where fraction_votes > (select	
	percentile_disc(0.9) within group (order by w.fraction_votes) as q_90
	from women w)
group by o.usa_over65
-- +14.39%


-- średni odsetek not_white w okręgach, gdzie wyniki dla kobiet są wyższe niż 90 
-- percentyl - o 93% więcej niż średnia 	
select avg(not_white ) from women w 
where fraction_votes > (select	
	percentile_disc(0.9) within group (order by w.fraction_votes) as q_90
	from women w)	
-- 43.52	

with usa_notwhite as (select not_white as usa_notwhite from counties where fips = 0)
select ((avg(not_white ) - usa_notwhite )/usa_notwhite)*100 as not_white_diff from women w2 , usa_notwhite
where fraction_votes > (select	
	percentile_disc(0.9) within group (order by w.fraction_votes) as q_90
	from women w)
group by usa_notwhite
-- +93.44%

-- średni odsetek osób o wykształceniu co najmniej bachelor w okręgach, gdzie wyniki 
-- dla kobiet są wyższe niż 90 percentyl - o 49% niższy niż średnia
select avg(education_bachelor_or_higher ) from women w 
where fraction_votes > (select	
	percentile_disc(0.9) within group (order by w.fraction_votes) as q_90
	from women w)	
-- 14.8

with usa_bachelor as (select education_bachelor_or_higher as usa_bachelor from counties where fips = 0)
select ((avg(education_bachelor_or_higher ) - usa_bachelor )/usa_bachelor)*100 as bachelor_diff from women w2 , usa_bachelor
where fraction_votes > (select	
	percentile_disc(0.9) within group (order by w.fraction_votes) as q_90
	from women w)
group by usa_bachelor
-- -48.76%
	
-- średni dochód roczny na głowę w okręgach, gdzie wyniki 
-- dla kobiet są wyższe niż 90 percentyl - o 32% niższy niż średnia	
select avg(income_per_capita_12months ) from women w 
where fraction_votes > (select	
	percentile_disc(0.9) within group (order by w.fraction_votes) as q_90
	from women w)	
-- 19156

with usa_income as (select income_per_capita_12months as usa_income from counties where fips = 0)
select ((avg(income_per_capita_12months ) - usa_income )/usa_income)*100 as income_diff from women w2 , usa_income
where fraction_votes > (select	
	percentile_disc(0.9) within group (order by w.fraction_votes) as q_90
	from women w)
group by usa_income
-- -31.96%
	
	
	
	