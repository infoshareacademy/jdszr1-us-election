select * from BenefitsCostSharing bcs ;
select * from BusinessRules br;
select * from Crosswalk2015 c where ;
select * from Crosswalk2016 c2 where ;
select * from Network n ;
select * from PlanAttributes pa where ;
select * from Rate r where ;
select * from ServiceArea sa;

-- po��czenie pomi�dzy tabelami po polu "StandardComponentId" ( wtabeli rate odpowiada ono polu PlanId)
-- => pozytywna informacja - liczebno�� unikalnych informacji jest taka sama dla tych p�l w 2016 roku w r�nych tabelach

-- nie znalaz�am jeszcze infromacji o "out-of-pocket maximum"
-- w tabeli BenefitsCostSharing bcs s� informacje o CoInsurance/CoPayment dla konkretnych us�ug  (mo�na ewentualnie / ale nie koniecznie ;-) / wy�wietla� jako dodatkowa informacja)
-- w tabeli PlanAttributes jest informacja o koszcie dedictable (dla rodziny i per osoba) i  jest nazwa marketingowa planu (do wy�wietlenia)
-- w tabeli Rate - s� sk�adki miesi�czne

-- poni�ej opis kr�tkiej analizy

select count(distinct StandardComponentId ) from BenefitsCostSharing bcs -- 8887
where BusinessYear =2016;

select count(distinct StandardComponentId ) from PlanAttributes pa -- 8887
where BusinessYear =2016;

select count(distinct PlanId) from Rate -- 8887
where BusinessYear = 2016;


select * from BenefitsCostSharing bcs
where StandardComponentId ='21989AK0080001';
-- 9 wierszy -- koszty CoInsurance/CoPayment dla konkretnych us�ug 
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
-- wydaje si� dobrym �r�d�em kosztu dedictable (dla rodziny i per osoba)
-- jeden wiersz - komponenty planu (du�o pustych p�l)
-- odp.czy dental_care
-- nazwa PlanMarketingName - mo�e do wy�wietlania dla klienta??!!
-- co oznaczaj� pola MEHB??!! s� tam ceny per group 700 per person 350, lub 150 per group i 50 per person 
-- czym te ceny si� r�ni�? (mo�naby pobiera� informacj� dla "person i mno�y� w zale�no�ci od ilo��o os�b?)

select * from Rate r
where r.PlanId = '21989AK0080001'
--and r.RateExpirationDate = ("2016-03-31") ; 
-- 12 wierszy 
-- r�ni si� ze wzgl�du na RatingAreaId (trzy rozne) i Rate Date (cztery daty dla 2016)
-- pomiedzy areaid ceny nie roznia sie w og�le, minimalna roznica jest dla dat (najwyzsza cena w najwyzszej dacie)

select * from BusinessRules br
where StandardComponentId ='21989AK0080001';