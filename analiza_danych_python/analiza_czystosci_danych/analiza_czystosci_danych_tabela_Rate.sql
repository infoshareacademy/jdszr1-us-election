-- og�lne wnioski:
-- 1. dla rodzin danych jest du�o mniej 
-- (czasami mo�e nie by� przeci�cia, kt�re wybierzemy, je�li ograniczymy si� do 2016, 
-- mo�e dla rodzin warto rozszerzy� o 2015, dla singli 2016 jest OK - cena po latach jest w miar� stablina)

-- 2. cena jest wrazliwa ze wzgl�du na stan

-- 3. cena vs wiek jest monotoniczna, czyli OK

-- 4. dziwna rozbie�ono�� w cenach dla singlii vs ceny dla rodzin 
-- (w przeci�ciu, �e rodzina jest uzupe�nionia, singiel ma te� du� ni�sz� cen�)
-- wklejam wyniki analizy, kt�re s� te� poni�ej:

-- dla wszytskich obserwacji => dziwna warto�� dla 2014 (Individual Rate), dziwne warto�ci �rednie dla Couple
--BusinessYear	"avg(IndividualRate)"	"avg(IndividualTobaccoRate)"	"avg(Couple)"
--2014			12922.257001081834		240.9262675359453				0.11666529869971129
--2015			329.1618612111573		198.4090849651623				0.1709630606070195
--2016			337.5392570717391		198.78076319826636				0.17232727414841065

-- z za�o�eniem "where Couple is not "" " => dane dla Rodzin mo�na bra� tylko z tym za�o�eniem, ale individual rate jest du�o ni�szy ni� w powy�szym przyk�adzie - dlaczego?
--BusinessYear	"avg(IndividualRate)"	"avg(IndividualTobaccoRate)"	"avg(Couple)"
--2014			26.435810546875224		0.0								48.05845703124995
--2015			31.53334210188623		0.0								51.29212113435128
--2016			26.821878678976514		0.0								45.080842679223906


-- ilosc wierszy w tabeli Rate;
select count(*) from Rate r; -- 12 694 445

-- czy s� nulle => nie ma
select count(*) from Rate r where BusinessYear is null; -- 0 
select count(*)  from Rate r where StateCode is null; -- 0 
select count(*)  from Rate r where IssuerId is null; -- 0 
select count(*)  from Rate r where SourceName is null; -- 0 
select count(*)  from Rate r where VersionNum is null; -- 0 
select count(*)  from Rate r where ImportDate is null; -- 0 
select count(*)  from Rate r where IssuerId2 is null; -- 0 
select count(*)  from Rate r where FederalTIN is null; -- 0 
select count(*)  from Rate r where RateEffectiveDate is null; -- 0 
select count(*)  from Rate r where RateExpirationDate is null; -- 0 
select count(*)  from Rate r where PlanId is null; -- 0 
select count(*)  from Rate r where RatingAreaId is null; -- 0 
select count(*)  from Rate r where Tobacco is null; -- 0 
select count(*)  from Rate r where Age is null; -- 0 
select count(*)  from Rate r where IndividualRate is null; -- 0 
select count(*)  from Rate r where IndividualTobaccoRate is null; -- 0 
select count(*)  from Rate r where Couple is null; -- 0 
select count(*)  from Rate r where PrimarySubscriberAndOneDependent is null; -- 0 
select count(*)  from Rate r where PrimarySubscriberAndTwoDependents is null; -- 0 
select count(*)  from Rate r where PrimarySubscriberAndThreeOrMoreDependents is null; -- 0 
select count(*)  from Rate r where CoupleAndOneDependent is null; -- 0 
select count(*)  from Rate r where CoupleAndTwoDependents is null; -- 0 
select count(*)  from Rate r where CoupleAndThreeOrMoreDependents is null; -- 0 
select count(*)  from Rate r where RowNumber is null; -- 0 

-- czy s� puste pola = > s� od pola couple...
select count(*) from Rate r where BusinessYear is ""; -- 0 
select count(*)  from Rate r where StateCode is ""; -- 0 
select count(*)  from Rate r where IssuerId is ""; -- 0 
select count(*)  from Rate r where SourceName is ""; -- 0 
select count(*)  from Rate r where VersionNum is ""; -- 0 
select count(*)  from Rate r where ImportDate is ""; -- 0 
select count(*)  from Rate r where IssuerId2 is ""; -- 0 
select count(*)  from Rate r where FederalTIN is ""; -- 0 
select count(*)  from Rate r where RateEffectiveDate is ""; -- 0 
select count(*)  from Rate r where RateExpirationDate is ""; -- 0 
select count(*)  from Rate r where PlanId is ""; -- 0 
select count(*)  from Rate r where RatingAreaId is ""; -- 0 
select count(*)  from Rate r where Tobacco is ""; -- 0 
select count(*)  from Rate r where Age is ""; -- 0 
select count(*)  from Rate r where IndividualRate is ""; -- 0 
select count(*)  from Rate r where IndividualTobaccoRate is ""; -- 7762096
select count(*)  from Rate r where Couple is ""; -- 12653504
select count(*)  from Rate r where PrimarySubscriberAndOneDependent is ""; -- 12653504
select count(*)  from Rate r where PrimarySubscriberAndTwoDependents is ""; -- 12653504 
select count(*)  from Rate r where PrimarySubscriberAndThreeOrMoreDependents is ""; -- 12653504
select count(*)  from Rate r where CoupleAndOneDependent is ""; -- 12653504 
select count(*)  from Rate r where CoupleAndTwoDependents is ""; -- 12653504 
select count(*)  from Rate r where CoupleAndThreeOrMoreDependents is ""; -- 12653504 
select count(*)  from Rate r where RowNumber is ""; -- 0 

-- sprawdzenie w jakich przypadkach Couple nie jest pustym polem;
select *  from Rate r where Couple is not "";
select distinct BusinessYear  from Rate r where Couple is not ""; -- wszytskie lata
select distinct StateCode  from Rate r where Couple is not ""; -- 36 stanow

-- liczebno�� obserwacji w kolejnych latach
select BusinessYear, count(*)  from Rate r group by BusinessYear ;
--2014	3 796 388
--2015	4 676 092
--2016	4 221 965

-- liczebno�� obserwacji w kolejnych latach, gdzie couple jest uzupe�nione 
select BusinessYear, count(*)  from Rate r where Couple is not "" group by BusinessYear ;
--2014	9 216
--2015	15 586
--2016	16 139

-- analogiczna analiza per stan - sprawdzenie minimalnych liczebno�ci (czy b�dzie na czym analizowa�)
-- liczebno�� obserwacji w kolejnych latach
select BusinessYear, StateCode, count(*)  from Rate r group by BusinessYear, StateCode ;
-- minimalna liczebno�� obserwacji, dla 2016 roku = 1518

-- liczebno�� obserwacji w kolejnych latach, gdzie couple jest uzupe�nione 
select BusinessYear, StateCode, count(*)  from Rate r where Couple is not "" group by BusinessYear, StateCode ;
-- minimalna liczebno�� obserwacji, dla 2016 roku = 6

-- r�nica w cenach per stan:
-- �rednia dla 2016 roku
select StateCode, 
avg(IndividualRate),
avg(IndividualTobaccoRate),
avg(Couple),
avg(PrimarySubscriberAndOneDependent),
avg(PrimarySubscriberAndTwoDependents),
avg(PrimarySubscriberAndThreeOrMoreDependents),
avg(CoupleAndOneDependent),
avg(CoupleAndTwoDependents),
avg(CoupleAndThreeOrMoreDependents)
from Rate r
where BusinessYear = 2016
and Couple is not ""
group by StateCode;

-- stan MT ma dziwne dane - jest tam tylko jedna �rednia, niezale�nie od tego, jaki plan (czy dla singla, czy dla couple)
-- => cena jest wrazliwa ze wzgl�du na stan, przyk�ad dla Individala:

--AL	17.694175824175826
--ME	19.33153846153846
--TN	19.741293103448275
--FL	22.2630442119474
--PA	22.683629629629593
--SC	24.06577173913047
--TX	24.07153846153846
--OK	24.652600000000046
--OH	25.26246323529403
--KS	25.29031746031748
--NC	25.32332908163253
--MO	25.386469387755138
--MT	25.965000000000007
--GA	26.40721153846152
--IN	27.021901260504144
--WV	27.589999999999996
--AZ	27.8223544973545
--NE	28.57093750000001
--WI	29.04561046511628
--LA	30.58287500000001
--WY	30.78937499999998
--IA	31.248701298701313
--NJ	32.01247191011237
--SD	32.55833333333332
--ND	32.82875
--UT	32.97
--VA	33.56289351851854
--AK	37.26422222222224
--IL	37.50725838264298
--NH	40.58
--MI	41.31227201257861

-- r�nica w cenach vs rok
select BusinessYear , 
avg(IndividualRate),
avg(IndividualTobaccoRate),
avg(Couple),
avg(PrimarySubscriberAndOneDependent),
avg(PrimarySubscriberAndTwoDependents),
avg(PrimarySubscriberAndThreeOrMoreDependents),
avg(CoupleAndOneDependent),
avg(CoupleAndTwoDependents),
avg(CoupleAndThreeOrMoreDependents)
from Rate r
where Couple is not ""
group by BusinessYear;

-- dla wszytskich obserwacji => dziwna warto�� dla 2014 (Individual Rate), dziwne warto�ci �rednie dla Couple
--BusinessYear	"avg(IndividualRate)"	"avg(IndividualTobaccoRate)"	"avg(Couple)"
--2014			12922.257001081834		240.9262675359453				0.11666529869971129
--2015			329.1618612111573		198.4090849651623				0.1709630606070195
--2016			337.5392570717391		198.78076319826636				0.17232727414841065

-- z za�o�eniem "where Couple is not "" " => dane dla Rodzin mo�na bra� tylko z tym za�o�eniem, ale individual rate jest du�o ni�szy ni� w powy�szym przyk�adzie - dlaczego?
--BusinessYear	"avg(IndividualRate)"	"avg(IndividualTobaccoRate)"	"avg(Couple)"
--2014			26.435810546875224		0.0								48.05845703124995
--2015			31.53334210188623		0.0								51.29212113435128
--2016			26.821878678976514		0.0								45.080842679223906

-- jakie warto�ci przyjmuj� pola - dla 2016 roku

-- je�li wybierzemy tylko pola z wype�nionymi danymi dla "Couple"
-- => og�lny wniosek, je�li zaw�zimy dane, tak, �e b�dzie tylko "Couple is not "" " - nie b�dziemy mogli u�y� Age jako zmiennej / To samo ze zmienn�: Tobacco.

select BusinessYear , count(*) from Rate r where BusinessYear = 2016 and Couple is not "" group by BusinessYear;
--2016	16139
select IssuerId , count(*) from Rate r where BusinessYear = 2016 and Couple is not "" group by IssuerId; 
-- 165 r�nych Issuer ID, minilana liczba obserwacji 2
select StateCode , count(*) from Rate r where BusinessYear = 2016 and Couple is not "" group by StateCode;
-- 31 stan�w, minimalna liczba obserwacji = 6
select SourceName, count(*) from Rate r where BusinessYear = 2016 and Couple is not "" group by SourceName;
--HIOS	12392
--SERFF	3747
select VersionNum, count(*) from Rate r where BusinessYear = 2016 and Couple is not "" group by VersionNum;
--1	714
--2	6770
--3	2449
--4	1542
--5	2362
--6	1720
--7	215
--8	15
--9	202
--11	54
--12	96
select IssuerId2, count(*) from Rate r where BusinessYear = 2016 and Couple is not "" group by IssuerId2;
-- 165 r�nych ID, min liczba obserwcji = 2
select FederalTIN, count(*) from Rate r where BusinessYear = 2016 and Couple is not "" group by FederalTIN;
-- 31 r�nych Federal TIN, minimalna liczba obserwacji = 4
select RateEffectiveDate, count(*) from Rate r where BusinessYear = 2016 and Couple is not "" group by RateEffectiveDate;
--2016-01-01	11474
--2016-04-01	1555
--2016-07-01	1555
--2016-10-01	1555
-- = > dziwna zbie�no�� 1555??!! ciekawe, czy co� si� nie powiela?
select RateExpirationDate, count(*) from Rate r where BusinessYear = 2016 and Couple is not "" group by RateExpirationDate;
--2016-03-31	1560
--2016-06-30	1555
--2016-09-30	1555
--2016-12-31	11469
select PlanId, count(*) from Rate r where BusinessYear = 2016 and Couple is not "" group by PlanId;
-- 777 r�nych PlanID, minimalna liczebno�� 1
select RatingAreaId, count(*) from Rate r where BusinessYear = 2016 and Couple is not "" group by RatingAreaId;
-- 67 r�nych Rating Area, minimalna liczba obserwacji 44
select Tobacco, count(*) from Rate r where BusinessYear = 2016 and Couple is not "" group by Tobacco;
--No Preference	16139
select Age, count(*) from Rate r where BusinessYear = 2016 and Couple is not "" group by Age;
-- Family Option	16139


-- wszystkie obserwcje, r�wnie� bez wype�nionej zmiennej Couple

select BusinessYear , count(*) from Rate r where BusinessYear = 2016 group by BusinessYear;
--2016	4221965
select IssuerId , count(*) from Rate r where BusinessYear = 2016  group by IssuerId; 
-- 770 r�nych Issuer ID, minilana liczba obserwacji 2
select StateCode , count(*) from Rate r where BusinessYear = 2016  group by StateCode;
-- 38 stan�w, minimalna liczba obserwacji = 1518
select SourceName, count(*) from Rate r where BusinessYear = 2016  group by SourceName;
--HIOS	2935692
--OPM	32798
--SERFF	1253475
select VersionNum, count(*) from Rate r where BusinessYear = 2016  group by VersionNum;
--1	160058
--2	283506
--3	523123
--4	732620
--5	371512
--6	453854
--7	379899
--8	247265
--9	459190
--10	164680
--11	49826
--12	24154
--13	108744
--14	127604
--15	45218
--16	16928
--17	690
--23	48254
--24	24840
select IssuerId2, count(*) from Rate r where BusinessYear = 2016  group by IssuerId2;
-- 770 r�nych ID, min liczba obserwcji = 2
select FederalTIN, count(*) from Rate r where BusinessYear = 2016  group by FederalTIN;
-- 287 r�nych Federal TIN, minimalna liczba obserwacji = 64
select RateEffectiveDate, count(*) from Rate r where BusinessYear = 2016  group by RateEffectiveDate;
--2015-01-01	1058
--2016-01-01	2669814
--2016-04-01	512799
--2016-07-01	525495
--2016-10-01	512799
-- = > dziwna zbie�no�� 512799??!! ciekawe, czy co� si� nie powiela?
select RateExpirationDate, count(*) from Rate r where BusinessYear = 2016  group by RateExpirationDate;
--2015-12-31	1058
--2016-03-31	512804
--2016-06-30	525495
--2016-09-30	512799
--2016-12-31	2666681
--2017-01-01	3128
select PlanId, count(*) from Rate r where BusinessYear = 2016  group by PlanId;
-- xxx r�nych PlanID
select RatingAreaId, count(*) from Rate r where BusinessYear = 2016  group by RatingAreaId;
-- 67 r�nych Rating Area, minimalna liczba obserwacji 5196 (5196 obserwacji powtarza si� dla 5 Rating Area)
select Tobacco, count(*) from Rate r where BusinessYear = 2016  group by Tobacco;
--No Preference	2730553
--Tobacco User/Non-Tobacco User	1491412
select Age, count(*) from Rate r where BusinessYear = 2016  group by Age;
--0-20	91431
--21	91431
--22	91431
--23	91431
--24	91431
--25	91431
--26	91431
--27	91431
--28	91431
--29	91431
--30	91431
--31	91431
--32	91431
--33	91431
--34	91431
-- .........
--64	91431
--65 and over	91431
--Family Option	16139
-- chyba pr�bka by�a podzielona vs wiek, zawsze tyle samo obserwacji (albo jest problem :) )

-- test: �rednia cena per wiek
 
select Age , 
avg(IndividualRate),
avg(IndividualTobaccoRate),
avg(Couple),
avg(PrimarySubscriberAndOneDependent),
avg(PrimarySubscriberAndTwoDependents),
avg(PrimarySubscriberAndThreeOrMoreDependents),
avg(CoupleAndOneDependent),
avg(CoupleAndTwoDependents),
avg(CoupleAndThreeOrMoreDependents)
from Rate r
where BusinessYear = 2016
group by Age;
-- jest monotoniczno�� wzgl�dem wieku
--0-20	126.20744692331981
--65 and over	580.5266570857383

-- dla "pary" i wi�cej os�b w rodzinie => dziwnie niskie warto�ci
select Age , 
avg(IndividualRate), -- 26
avg(IndividualTobaccoRate), -- 0
avg(Couple), -- 45
avg(PrimarySubscriberAndOneDependent), --47
avg(PrimarySubscriberAndTwoDependents), --67
avg(PrimarySubscriberAndThreeOrMoreDependents), --84
avg(CoupleAndOneDependent), --69
avg(CoupleAndTwoDependents), -- 84
avg(CoupleAndThreeOrMoreDependents) -- 102
from Rate r
where BusinessYear = 2016
and Couple is not ""
group by Age;


