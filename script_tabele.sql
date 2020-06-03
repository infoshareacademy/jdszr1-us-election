-- county_facts_dictionary definition

CREATE TABLE county_facts_dictionary(
    column_name TEXT,
    description TEXT);
    
select * from county_facts_dictionary

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
  

-- Utworzenie tabeli candidates, zawierającej dane o kandydatach
  
  create table candidates (
  	candidate text,
  	party text,
  	gender text,
  	rase text,
  	year_of_birth int,
  	age_2016 int
  );
 
  select * from candidates c 
  
  
  
  
  
  
   

   
   