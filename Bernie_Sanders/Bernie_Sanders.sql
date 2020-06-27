-- zapytania ogólne:
-- suma wszystkich g³osów oddanych w wyborach

select sum(votes)
  from primary_results pr
 where pr.fips not in ('36085', '46113', '36047');
-- 56 389 066 

 -- wszystkie g³osy na demokratów i republikanów (przy zachowaniu wykluczeñ opisanych w pliku o czystoœci danych) 

select pr.party, sum(votes)
  from primary_results pr
 where pr.fips not in ('36085', '46113', '36047');
 group by pr.party;
--Republican	29 050 594
--Democrat	    27 338 472

-- analiza dla 'Bernie Sanders'
-- wszystkie g³osy na Bernie Sanders (przy zachowaniu wykluczeñ opisanych w pliku o czystoœci danych) 

select sum(votes)
  from primary_results pr
 where pr.candidate = 'Bernie Sanders'
   and pr.fips not in ('36085', '46113', '36047');
-- 11 827 861

-- wyniki BS w 10 najlepszych stanach
select pr.state, 
	   sum(votes)
  from primary_results pr
 where pr.candidate = 'Bernie Sanders'
   and pr.fips not in ('36085', '46113', '36047')
 group by pr.state 
 order by sum(votes) desc 
 limit 10;

--California	1 502 043
--Illinois	975 659
--Pennsylvania	719 955
--New York	632 802
--Michigan	595 222
--Massachusetts	586 716
--Wisconsin	567 936
--Florida	566 603
--Ohio	513 549
--Texas	475 561


-- funkcja wyci¹gaj¹ca liczbê g³osów dla kandydata
create or replace function f_candidate_all(kandydat varchar) returns table(
	       candidate varchar, 
	       party varchar,  
	       s_votes int8
)
language sql as ' 
	select pr.candidate, 
		   pr.party, 
		   sum(pr.votes) s_votes
	  from primary_results pr
	 where pr.candidate=kandydat
	   and pr.fips not in (''36085'', ''46113'', ''36047'')
	 group by pr.candidate, pr.party 
'; 


-- funkcja wyci¹gaj¹ca liczbê g³osów dla partii danego kandydata
create or replace function f_party_all(kandydat varchar) returns table( 
	      party varchar,  
	      s_votes int8
)
language sql as ' 
	select pr.party, 
		   sum(pr.votes) s_votes
	  from primary_results pr
	 where pr.party in (select party from primary_results where candidate=kandydat)
	   and pr.fips not in (''36085'', ''46113'', ''36047'')
	 group by pr.party 
'; 

-- ile g³osów w jakim stanie & udzia³ procentowy w sumie swoich g³osów, w sumie g³osów swojej partii oraz w sumie wszytskich g³osów
-- 5 stanów z najlepszym wynikiem
create or replace function stany_z_najlepszym_wynikiem(kandydat varchar) returns table( 
	       state varchar,
	       state_abbreviation varchar,
	       candidate varchar,
	       party varchar,
	       bs_votes int8,
	       all_votes_BS numeric,
	       perc_BS_votes numeric,
	       all_party_votes numeric,
	       perc_of_party_votes numeric,
	       all_votes int8,
	       perc_of_all_voats int8
 )
language sql as ' 
select pr.state ,
	   pr.state_abbreviation ,
	   pr.candidate,
	   pr.party ,
	   sum(pr.votes) bs_votes ,
	   sum(ca.s_votes)/ count(pr.candidate)::int4 all_votes_BS ,
	   sum(pr.votes) / (sum(ca.s_votes)/ count(pr.candidate)) perc_BS_votes,
	   sum(pa.s_votes)/count(pr.party) all_party_votes,
	   sum(pr.votes)/(sum(pa.s_votes)/count(pr.party)) perc_of_party_votes,
	   (select sum(pr.votes) s_votes
	      from primary_results pr
	     where pr.fips not in (''36085'', ''46113'', ''36047'')) all_votes,
	   sum(pr.votes)/ (select sum(pr.votes) s_votes
	                     from primary_results pr
	                    where pr.fips not in (''36085'', ''46113'', ''36047'')) perc_of_all_voats
  from primary_results pr
  left join f_candidate_all(kandydat) ca on pr.candidate = ca.candidate
  left join f_party_all(kandydat) pa on pr.party = pa.party
 where pr.candidate = ca.candidate 
   and pr.party = ca.party
   and pr.fips not in (''36085'', ''46113'', ''36047'')
 group by pr.state,
	   pr.state_abbreviation,
	   pr.candidate,
	   pr.party
 order by sum(pr.votes) desc
 limit 5'
   
select * from stany_z_najlepszym_wynikiem('Bernie Sanders');

--California	CA	Bernie Sanders	Democrat	1502043	11827861.000000000000	0.12699193877912498295	27338472.000000000000	0.05494246349978886896	56389066	0
--Illinois	IL	Bernie Sanders	Democrat	975659	11827861.000000000000	0.08248820306562615168	27338472.000000000000	0.03568813209458085295	56389066	0
--Pennsylvania	PA	Bernie Sanders	Democrat	719955	11827861.000000000000	0.06086941671025724770	27338472.000000000000	0.02633486611834048370	56389066	0
--New York	NY	Bernie Sanders	Democrat	632802	11827861.000000000000	0.05350096691193783897	27338472.000000000000	0.02314694105800792378	56389066	0
--Michigan	MI	Bernie Sanders	Democrat	595222	11827861.000000000000	0.05032372294534066641	27338472.000000000000	0.02177232143771605085	56389066	0

-- 5 stanów z najgorszym wynikiem
create or replace function stany_z_najgorszym_wynikiem(kandydat varchar) returns table( 
	       state varchar,
	       state_abbreviation varchar,
	       candidate varchar,
	       party varchar,
	       bs_votes int8,
	       all_votes_BS numeric,
	       perc_BS_votes numeric,
	       all_party_votes numeric,
	       perc_of_party_votes numeric,
	       all_votes int8,
	       perc_of_all_voats int8
 )
language sql as ' 
select pr.state ,
	   pr.state_abbreviation ,
	   pr.candidate,
	   pr.party ,
	   sum(pr.votes) bs_votes ,
	   sum(ca.s_votes)/ count(pr.candidate)::int4 all_votes_BS ,
	   sum(pr.votes) / (sum(ca.s_votes)/ count(pr.candidate)) perc_BS_votes,
	   sum(pa.s_votes)/count(pr.party) all_party_votes,
	   sum(pr.votes)/(sum(pa.s_votes)/count(pr.party)) perc_of_party_votes,
	   (select sum(pr.votes) s_votes
	      from primary_results pr
	     where pr.fips not in (''36085'', ''46113'', ''36047'')) all_votes,
	   sum(pr.votes)/ (select sum(pr.votes) s_votes
	                     from primary_results pr
	                    where pr.fips not in (''36085'', ''46113'', ''36047'')) perc_of_all_voats
  from primary_results pr
  left join f_candidate_all(kandydat) ca on pr.candidate = ca.candidate
  left join f_party_all(kandydat) pa on pr.party = pa.party
 where pr.candidate = ca.candidate 
   and pr.party = ca.party
   and pr.fips not in (''36085'', ''46113'', ''36047'')
 group by pr.state,
	   pr.state_abbreviation,
	   pr.candidate,
	   pr.party
 order by sum(pr.votes) asc
 limit 5'
   
select * from stany_z_najgorszym_wynikiem('Bernie Sanders');

--Wyoming	WY	Bernie Sanders	Democrat	156	11827861.000000000000	0.000013189197945427326209	27338472.000000000000	0.000005706244299242474122	56389066	0
--North Dakota	ND	Bernie Sanders	Democrat253	11827861.000000000000	0.000021390173590981496993	27338472.000000000000	0.000009254357741720166365	56389066	0
--Alaska	AK	Bernie Sanders	Democrat	440	11827861.000000000000	0.000037200301897359125204	27338472.000000000000	0.000016094535202991593678	56389066	0
--Maine	ME	Bernie Sanders	Democrat	   2201	11827861.000000000000	0.00018608605562747144	27338472.000000000000	0.000080509254504055676557	56389066	0
--Nevada NV	Bernie Sanders	Democrat       5641	11827861.000000000000	0.00047692477955227915	27338472.000000000000	0.00020633925700017177	56389066	0


-- jak¹ liczbê g³osów otrzymali inni kandydaci w stanach z najwyzszym wynikiem Berniego Sandersa (prezentacja xls)

   select pr.state,
	      pr.candidate,
	      pr.party ,
	      sum(pr.votes) as candidate_votes ,
	      snw.bs_votes,
   	      snw.all_votes,
	      sum(snw.bs_votes)/ sum(snw.all_votes) as bs_perc_votes,
	      sum(pr.votes)/ (sum(snw.all_votes)/count(snw.all_votes)) as candidate_perc_votes	
     from primary_results pr
left join stany_z_najlepszym_wynikiem('Bernie Sanders') snw on trim(lower(pr.state)) = trim(lower(snw.state))
    where trim(lower(pr.state)) = trim(lower(snw.state))
	  and pr.fips not in ('36085', '46113', '36047')
    group by pr.state,
	      pr.candidate ,
	      pr.party,
	      snw.bs_votes,
	      snw.all_votes,
	      snw.perc_of_all_voats
 order by pr.party,
       	  pr.candidate,
	      sum(pr.votes) desc;

-- jak¹ liczbê g³osów otrzymali inni kandydaci w stanach z najnizszym wynikiem Berniego Sandersa  (prezentacja xls)

   select pr.state,
	      pr.candidate,
	      pr.party ,
	      sum(pr.votes) as candidate_votes ,
	      snw.bs_votes,
   	      snw.all_votes,
	      sum(snw.bs_votes)/ sum(snw.all_votes) as bs_perc_votes,
	      sum(pr.votes)/ (sum(snw.all_votes)/count(snw.all_votes)) as candidate_perc_votes	
     from primary_results pr
left join stany_z_najgorszym_wynikiem('Bernie Sanders') snw on trim(lower(pr.state)) = trim(lower(snw.state))
    where trim(lower(pr.state)) = trim(lower(snw.state))
	  and pr.fips not in ('36085', '46113', '36047')
    group by pr.state,
	      pr.candidate ,
	      pr.party,
	      snw.bs_votes,
	      snw.all_votes,
	      snw.perc_of_all_voats
 order by pr.party,
       	  pr.candidate,
	      sum(pr.votes) desc;

-- lista kandydatów pogrupowana wg uzyskanej liczby g³osów => Bernie Sanders by³ 3
 select pr.party ,
	    pr.candidate ,
	    sum(pr.votes) s_votes
   from primary_results pr
  where pr.fips not in ('36085', '46113', '36047')
  group by pr.party,
        pr.candidate
  order by sum(pr.votes) desc
  limit 5;

--Democrat	Hillary Clinton	15501664
--Republican	Donald Trump	13267246
--Democrat	Bernie Sanders	11827861
--Republican	Ted Cruz	7596469
--Republican	John Kasich	4153689

-- ile g³osów w jakim hrabstwie = 10 hrabstw z najwyzszym wynikem BS
 select pr.state,
	    pr.county ,
	    sum(pr.votes)
   from primary_results pr
  where	pr.candidate = 'Bernie Sanders'
    and	pr.fips not in ('36085', '46113', '36047')
  group by pr.state,
  		pr.county
  order by sum(pr.votes) desc
  limit 10;
 
--California	Los Angeles	434656
--Illinois	Chicago	311225
--Illinois	Cook Suburbs	212428
--Pennsylvania	Philadelphia	125688
--California	San Diego	111898
--Michigan	Wayne	104999
--Wisconsin	Dane	102585
--California	Orange	100836
--Pennsylvania	Allegheny	98012
--Wisconsin	Milwaukee	93714

-- ile g³osów w jakim hrabstwie = 10 hrabstw z najnizszym wynikem BS
 select pr.state,
	    pr.county ,
	    sum(pr.votes)
   from primary_results pr
  where	pr.candidate = 'Bernie Sanders'
    and	pr.fips not in ('36085', '46113', '36047')
  group by pr.state,
  		pr.county
  order by sum(pr.votes) asc
  limit 10;

--Maine	Waite	0
--Maine	Coplin Plt.	0
--Maine	Highland Plt.	0
--Maine	Swan's Island	0
--Maine	Westfield	0
--Maine	Springfield	0
--Maine	Wellington	0
--Maine	Otis	0
--Maine	West Forks Plt.	0
--Nebraska	Grant	0

-- analiza zmiennych demograficznych z tabeli counties c dla BS, Demokratów i Republikanów  (prezentacja xls)

-- Bernie Sanders
-- hrabstwa z najwyzszym wynikiem

with hrabstwa_z_najwyzszym_wynikiem as ( with candidate_all as (

select pr.candidate, 
	   pr.party, 
	   sum(pr.votes) s_votes
  from primary_results pr
 where pr.fips not in ('36085', '46113', '36047')
 group by pr.candidate,
          pr.party )
select pr.fips, 
	   pr.county, 
	   pr.state , 
	   pr.state_abbreviation , 
	   pr.candidate , 
	   pr.party , 
	   sum(pr.votes) votes_BS , 
	   sum(ca.s_votes)/ count(pr.county)::int4 votes_all , 
	   count(pr.county) ile_hrabstw , 
	   sum(pr.votes) / (sum(ca.s_votes)/ count(pr.county)) perc_votes
  from primary_results pr
  left join candidate_all ca on pr.candidate = ca.candidate
 where pr.candidate = 'Bernie Sanders'
   and ca.candidate = 'Bernie Sanders'
   and pr.party = ca.party
   and pr.fips not in ('36085', '46113', '36047')
 group by pr.fips, 
       pr.county, 
       pr.state, 
       pr.state_abbreviation, 
       pr.candidate, 
       pr.party
 order by sum(pr.votes) desc
 limit 20)

select c.area_name, 
	   c.age_over65, 
	   c.education_bachelor_or_higher, 
	   c.education_highschool_or_higher, 
	   c.female, 
	   c.foreign_born,
	   c.hawaii_and_pacific , 
	   c.hispanic_latino, 
	   c.income_household_median, 
	   c.income_per_capita_12months , 
	   c.indian_or_alaska,
	   c.asian, 
	   c.black, 
	   c.many_races, 
	   c.not_white, 
	   c.other_language_home , 
	   c.population, 
	   c.veterans, 
	   c.white, 
	   c.white_not_hispanic_or_latino, 
	   snw2.state,
	   snw2.candidate,
	   snw2.party ,
	   snw2.votes_BS,
	   snw2.votes_all,
	   snw2.perc_votes BS_perc_votes
  from counties c
 right join hrabstwa_z_najwyzszym_wynikiem snw2 on c.fips = snw2.fips
 where c.fips = snw2.fips
 group by c.area_name, 
	   c.age_over65, 
	   c.education_bachelor_or_higher, 
	   c.education_highschool_or_higher, 
	   c.female, 
	   c.foreign_born,
	   c.hawaii_and_pacific , 
	   c.hispanic_latino, 
	   c.income_household_median, 
	   c.income_per_capita_12months , 
	   c.indian_or_alaska,
	   c.asian, 
	   c.black, 
	   c.many_races, 
	   c.not_white, 
	   c.other_language_home , 
	   c.population, 
	   c.veterans, 
	   c.white, 
	   c.white_not_hispanic_or_latino, 
	   snw2.state,
	   snw2.candidate,
	   snw2.party ,
	   snw2.votes_BS,
	   snw2.votes_all,
	   snw2.perc_votes;
	  
-- hrabstwa z najnizszym wynikiem

with hrabstwa_z_najnizszym_wynikiem as ( with candidate_all as (

select pr.candidate, 
	   pr.party, 
	   sum(pr.votes) s_votes
  from primary_results pr
 where pr.fips not in ('36085', '46113', '36047')
 group by pr.candidate,
          pr.party )
select pr.fips, 
	   pr.county, 
	   pr.state , 
	   pr.state_abbreviation , 
	   pr.candidate , 
	   pr.party , 
	   sum(pr.votes) votes_BS , 
	   sum(ca.s_votes)/ count(pr.county)::int4 votes_all , 
	   count(pr.county) ile_hrabstw , 
	   sum(pr.votes) / (sum(ca.s_votes)/ count(pr.county)) perc_votes
  from primary_results pr
  left join candidate_all ca on pr.candidate = ca.candidate
 where pr.candidate = 'Bernie Sanders'
   and ca.candidate = 'Bernie Sanders'
   and pr.party = ca.party
   and pr.fips not in ('36085', '46113', '36047')
 group by pr.fips, 
       pr.county, 
       pr.state, 
       pr.state_abbreviation, 
       pr.candidate, 
       pr.party
 order by sum(pr.votes) asc
 limit 100)

select c.area_name, 
	   c.age_over65, 
	   c.education_bachelor_or_higher, 
	   c.education_highschool_or_higher, 
	   c.female, 
	   c.foreign_born,
	   c.hawaii_and_pacific , 
	   c.hispanic_latino, 
	   c.income_household_median, 
	   c.income_per_capita_12months , 
	   c.indian_or_alaska,
	   c.asian, 
	   c.black, 
	   c.many_races, 
	   c.not_white, 
	   c.other_language_home , 
	   c.population, 
	   c.veterans, 
	   c.white, 
	   c.white_not_hispanic_or_latino, 
	   snw2.state,
	   snw2.candidate,
	   snw2.party ,
	   snw2.votes_BS,
	   snw2.votes_all,
	   snw2.perc_votes BS_perc_votes
  from counties c
 right join hrabstwa_z_najnizszym_wynikiem snw2 on c.fips = snw2.fips
 where c.fips = snw2.fips
 group by c.area_name, 
	   c.age_over65, 
	   c.education_bachelor_or_higher, 
	   c.education_highschool_or_higher, 
	   c.female, 
	   c.foreign_born,
	   c.hawaii_and_pacific , 
	   c.hispanic_latino, 
	   c.income_household_median, 
	   c.income_per_capita_12months , 
	   c.indian_or_alaska,
	   c.asian, 
	   c.black, 
	   c.many_races, 
	   c.not_white, 
	   c.other_language_home , 
	   c.population, 
	   c.veterans, 
	   c.white, 
	   c.white_not_hispanic_or_latino, 
	   snw2.state,
	   snw2.candidate,
	   snw2.party ,
	   snw2.votes_BS,
	   snw2.votes_all,
	   snw2.perc_votes;

-- DEMOKRACI - analiza demograficzna dla hrabstw
with hrabstwa_z_najwyzszym_wynikiem as ( with candidate_all as (

select pr.party, 
	   sum(pr.votes) s_votes
  from primary_results pr
 where pr.fips not in ('36085', '46113', '36047')
 group by pr.party )
select pr.fips, 
	   pr.county, 
	   pr.state , 
	   pr.state_abbreviation ,
	   pr.party , 
	   sum(pr.votes) votes_BS , 
	   sum(ca.s_votes)/ count(pr.county)::int4 votes_all , 
	   count(pr.county) ile_hrabstw , 
	   sum(pr.votes) / (sum(ca.s_votes)/ count(pr.county)) perc_votes
  from primary_results pr
  left join candidate_all ca on pr.party = ca.party
 where pr.party = ca.party
   and pr.party ='Democrat' --'Republican'
   and pr.fips not in ('36085', '46113', '36047')
 group by pr.fips, 
       pr.county, 
       pr.state, 
       pr.state_abbreviation, 
       pr.party
 order by sum(pr.votes) desc
 limit 20)

select c.area_name, 
	   c.age_over65, 
	   c.education_bachelor_or_higher, 
	   c.education_highschool_or_higher, 
	   c.female, 
	   c.foreign_born,
	   c.hawaii_and_pacific , 
	   c.hispanic_latino, 
	   c.income_household_median, 
	   c.income_per_capita_12months , 
	   c.indian_or_alaska,
	   c.asian, 
	   c.black, 
	   c.many_races, 
	   c.not_white, 
	   c.other_language_home , 
	   c.population, 
	   c.veterans, 
	   c.white, 
	   c.white_not_hispanic_or_latino, 
	   snw2.state,
	   snw2.party ,
	   snw2.votes_all
  from counties c
 right join hrabstwa_z_najwyzszym_wynikiem snw2 on c.fips = snw2.fips
 where c.fips = snw2.fips
 group by c.area_name, 
	   c.age_over65, 
	   c.education_bachelor_or_higher, 
	   c.education_highschool_or_higher, 
	   c.female, 
	   c.foreign_born,
	   c.hawaii_and_pacific , 
	   c.hispanic_latino, 
	   c.income_household_median, 
	   c.income_per_capita_12months , 
	   c.indian_or_alaska,
	   c.asian, 
	   c.black, 
	   c.many_races, 
	   c.not_white, 
	   c.other_language_home , 
	   c.population, 
	   c.veterans, 
	   c.white, 
	   c.white_not_hispanic_or_latino, 
	   snw2.state,
	   snw2.party ,
	   snw2.votes_BS,
	   snw2.votes_all,
	   snw2.perc_votes;
	  
-- hrabstwa z najnizszym wynikiem

with hrabstwa_z_najwyzszym_wynikiem as ( with candidate_all as (

select pr.party, 
	   sum(pr.votes) s_votes
  from primary_results pr
 where pr.fips not in ('36085', '46113', '36047')
 group by pr.party )
select pr.fips, 
	   pr.county, 
	   pr.state , 
	   pr.state_abbreviation ,
	   pr.party , 
	   sum(pr.votes) votes_BS , 
	   sum(ca.s_votes)/ count(pr.county)::int4 votes_all , 
	   count(pr.county) ile_hrabstw , 
	   sum(pr.votes) / (sum(ca.s_votes)/ count(pr.county)) perc_votes
  from primary_results pr
  left join candidate_all ca on pr.party = ca.party
 where pr.party = ca.party
   and pr.party ='Democrat' --'Republican'
   and pr.fips not in ('36085', '46113', '36047')
 group by pr.fips, 
       pr.county, 
       pr.state, 
       pr.state_abbreviation, 
       pr.party
 order by sum(pr.votes) asc
 limit 100)

select c.area_name, 
	   c.age_over65, 
	   c.education_bachelor_or_higher, 
	   c.education_highschool_or_higher, 
	   c.female, 
	   c.foreign_born,
	   c.hawaii_and_pacific , 
	   c.hispanic_latino, 
	   c.income_household_median, 
	   c.income_per_capita_12months , 
	   c.indian_or_alaska,
	   c.asian, 
	   c.black, 
	   c.many_races, 
	   c.not_white, 
	   c.other_language_home , 
	   c.population, 
	   c.veterans, 
	   c.white, 
	   c.white_not_hispanic_or_latino, 
	   snw2.state,
	   snw2.party ,
	   snw2.votes_all
  from counties c
 right join hrabstwa_z_najwyzszym_wynikiem snw2 on c.fips = snw2.fips
 where c.fips = snw2.fips
 group by c.area_name, 
	   c.age_over65, 
	   c.education_bachelor_or_higher, 
	   c.education_highschool_or_higher, 
	   c.female, 
	   c.foreign_born,
	   c.hawaii_and_pacific , 
	   c.hispanic_latino, 
	   c.income_household_median, 
	   c.income_per_capita_12months , 
	   c.indian_or_alaska,
	   c.asian, 
	   c.black, 
	   c.many_races, 
	   c.not_white, 
	   c.other_language_home , 
	   c.population, 
	   c.veterans, 
	   c.white, 
	   c.white_not_hispanic_or_latino, 
	   snw2.state,
	   snw2.party ,
	   snw2.votes_BS,
	   snw2.votes_all,
	   snw2.perc_votes;
	  
	  
-- REPUBLIKANIE - analiza demograficzna dla hrabstw
with hrabstwa_z_najwyzszym_wynikiem as ( with candidate_all as (

select pr.party, 
	   sum(pr.votes) s_votes
  from primary_results pr
 where pr.fips not in ('36085', '46113', '36047')
 group by pr.party )
select pr.fips, 
	   pr.county, 
	   pr.state , 
	   pr.state_abbreviation ,
	   pr.party , 
	   sum(pr.votes) votes_BS , 
	   sum(ca.s_votes)/ count(pr.county)::int4 votes_all , 
	   count(pr.county) ile_hrabstw , 
	   sum(pr.votes) / (sum(ca.s_votes)/ count(pr.county)) perc_votes
  from primary_results pr
  left join candidate_all ca on pr.party = ca.party
 where pr.party = ca.party
   and pr.party ='Republican'
   and pr.fips not in ('36085', '46113', '36047')
 group by pr.fips, 
       pr.county, 
       pr.state, 
       pr.state_abbreviation, 
       pr.party
 order by sum(pr.votes) desc
 limit 20)

select c.area_name, 
	   c.age_over65, 
	   c.education_bachelor_or_higher, 
	   c.education_highschool_or_higher, 
	   c.female, 
	   c.foreign_born,
	   c.hawaii_and_pacific , 
	   c.hispanic_latino, 
	   c.income_household_median, 
	   c.income_per_capita_12months , 
	   c.indian_or_alaska,
	   c.asian, 
	   c.black, 
	   c.many_races, 
	   c.not_white, 
	   c.other_language_home , 
	   c.population, 
	   c.veterans, 
	   c.white, 
	   c.white_not_hispanic_or_latino, 
	   snw2.state,
	   snw2.party ,
	   snw2.votes_all
  from counties c
 right join hrabstwa_z_najwyzszym_wynikiem snw2 on c.fips = snw2.fips
 where c.fips = snw2.fips
 group by c.area_name, 
	   c.age_over65, 
	   c.education_bachelor_or_higher, 
	   c.education_highschool_or_higher, 
	   c.female, 
	   c.foreign_born,
	   c.hawaii_and_pacific , 
	   c.hispanic_latino, 
	   c.income_household_median, 
	   c.income_per_capita_12months , 
	   c.indian_or_alaska,
	   c.asian, 
	   c.black, 
	   c.many_races, 
	   c.not_white, 
	   c.other_language_home , 
	   c.population, 
	   c.veterans, 
	   c.white, 
	   c.white_not_hispanic_or_latino, 
	   snw2.state,
	   snw2.party ,
	   snw2.votes_BS,
	   snw2.votes_all,
	   snw2.perc_votes;
	  
-- hrabstwa z najnizszym wynikiem

with hrabstwa_z_najwyzszym_wynikiem as ( with candidate_all as (

select pr.party, 
	   sum(pr.votes) s_votes
  from primary_results pr
 where pr.fips not in ('36085', '46113', '36047')
 group by pr.party )
select pr.fips, 
	   pr.county, 
	   pr.state , 
	   pr.state_abbreviation ,
	   pr.party , 
	   sum(pr.votes) votes_BS , 
	   sum(ca.s_votes)/ count(pr.county)::int4 votes_all , 
	   count(pr.county) ile_hrabstw , 
	   sum(pr.votes) / (sum(ca.s_votes)/ count(pr.county)) perc_votes
  from primary_results pr
  left join candidate_all ca on pr.party = ca.party
 where pr.party = ca.party
   and pr.party ='Republican'
   and pr.fips not in ('36085', '46113', '36047')
 group by pr.fips, 
       pr.county, 
       pr.state, 
       pr.state_abbreviation, 
       pr.party
 order by sum(pr.votes) asc
 limit 100)

select c.area_name, 
	   c.age_over65, 
	   c.education_bachelor_or_higher, 
	   c.education_highschool_or_higher, 
	   c.female, 
	   c.foreign_born,
	   c.hawaii_and_pacific , 
	   c.hispanic_latino, 
	   c.income_household_median, 
	   c.income_per_capita_12months , 
	   c.indian_or_alaska,
	   c.asian, 
	   c.black, 
	   c.many_races, 
	   c.not_white, 
	   c.other_language_home , 
	   c.population, 
	   c.veterans, 
	   c.white, 
	   c.white_not_hispanic_or_latino, 
	   snw2.state,
	   snw2.party ,
	   snw2.votes_all
  from counties c
 right join hrabstwa_z_najwyzszym_wynikiem snw2 on c.fips = snw2.fips
 where c.fips = snw2.fips
 group by c.area_name, 
	   c.age_over65, 
	   c.education_bachelor_or_higher, 
	   c.education_highschool_or_higher, 
	   c.female, 
	   c.foreign_born,
	   c.hawaii_and_pacific , 
	   c.hispanic_latino, 
	   c.income_household_median, 
	   c.income_per_capita_12months , 
	   c.indian_or_alaska,
	   c.asian, 
	   c.black, 
	   c.many_races, 
	   c.not_white, 
	   c.other_language_home , 
	   c.population, 
	   c.veterans, 
	   c.white, 
	   c.white_not_hispanic_or_latino, 
	   snw2.state,
	   snw2.party ,
	   snw2.votes_BS,
	   snw2.votes_all,
	   snw2.perc_votes;
	  