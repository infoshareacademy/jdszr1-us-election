select * from BenefitsCostSharing bcs ;
select * from BusinessRules br;
select * from Crosswalk2015 c where ;
select * from Crosswalk2016 c2 where ;
select * from Network n ;
select * from PlanAttributes pa where ;
select * from Rate r where ;
select * from ServiceArea sa;

-- po³¹czenie pomiêdzy tabelami po polu "StandardComponentId" ( wtabeli rate odpowiada ono polu PlanId)
-- => pozytywna informacja - liczebnoœæ unikalnych informacji jest taka sama dla tych pól w 2016 roku w ró¿nych tabelach

-- nie znalaz³am jeszcze infromacji o "out-of-pocket maximum"
-- w tabeli BenefitsCostSharing bcs s¹ informacje o CoInsurance/CoPayment dla konkretnych us³ug  (mo¿na ewentualnie / ale nie koniecznie ;-) / wyœwietlaæ jako dodatkowa informacja)
-- w tabeli PlanAttributes jest informacja o koszcie dedictable (dla rodziny i per osoba) i  jest nazwa marketingowa planu (do wyœwietlenia)
-- w tabeli Rate - s¹ sk³adki miesiêczne

-- poni¿ej opis krótkiej analizy

select count(distinct StandardComponentId ) from BenefitsCostSharing bcs -- 8887
where BusinessYear =2016;

select count(distinct StandardComponentId ) from PlanAttributes pa -- 8887
where BusinessYear =2016;

select count(distinct PlanId) from Rate -- 8887
where BusinessYear = 2016;


select * from BenefitsCostSharing bcs
where StandardComponentId ='21989AK0080001';
-- 9 wierszy -- koszty CoInsurance/CoPayment dla konkretnych us³ug 
--Kolumna "BenefitName"
--Routine Dental Services (Adult)
--Dental Check-Up for Children
--Basic Dental Care - Child
--Orthodontia - Child
--Major Dental Care - Child
--Basic Dental Care - Adult
--Orthodontia - Adult
--Major Dental Care - Adult
--Accidental Dental

select * from PlanAttributes pa
where StandardComponentId ='21989AK0080001';
-- wydaje siê dobrym Ÿród³em kosztu dedictable (dla rodziny i per osoba)
-- jeden wiersz - komponenty planu (du¿o pustych pól)
-- odp.czy dental_care
-- nazwa PlanMarketingName - mo¿e do wyœwietlania dla klienta??!!
-- co oznaczaj¹ pola MEHB??!! s¹ tam ceny per group 700 per person 350, lub 150 per group i 50 per person 
-- czym te ceny siê ró¿ni¹? (mo¿naby pobieraæ informacjê dla "person i mno¿yæ w zale¿noœci od iloœæo osób?)

select * from Rate r
where r.PlanId = '21989AK0080001'
--and r.RateExpirationDate = ("2016-03-31") ; 
-- 12 wierszy 
-- ró¿ni siê ze wzglêdu na RatingAreaId (trzy rozne) i Rate Date (cztery daty dla 2016)
-- pomiedzy areaid ceny nie roznia sie w ogóle, minimalna roznica jest dla dat (najwyzsza cena w najwyzszej dacie)

select * from BusinessRules br
where StandardComponentId ='21989AK0080001';