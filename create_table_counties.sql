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