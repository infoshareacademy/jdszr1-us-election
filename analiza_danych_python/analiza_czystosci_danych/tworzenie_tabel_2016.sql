select * from BenefitsCostSharing bcs ;
select * from BusinessRules br;
--select * from Crosswalk2015 c;
--select * from Crosswalk2016 c2;
select * from Network n ;
select * from PlanAttributes pa;
select * from Rate r;
select * from ServiceArea sa;


create table BenefitsCostSharing2016 as
select * from BenefitsCostSharing bcs
where bcs.BusinessYear = 2016;

select max(rowid)  from BenefitsCostSharing2016;
select count(*)  from BenefitsCostSharing2016 c;

create table BenefitsCostSharing2016_v1 as
select * from BenefitsCostSharing2016 bcs
where rowid<180426;

select * from BenefitsCostSharing2016_v1

create table BenefitsCostSharing2016_v2 as
select * from BenefitsCostSharing2016 bcs
where rowid >= 180426
and rowid <300000;

create table BenefitsCostSharing2016_v3 as
select * from BenefitsCostSharing2016 bcs
where rowid >= 300000
and rowid <400000;

create table BenefitsCostSharing2016_v4 as
select * from BenefitsCostSharing2016 bcs
where rowid >= 400000
and rowid <500000;

create table BenefitsCostSharing2016_v5 as
select * from BenefitsCostSharing2016 bcs
where rowid >= 500000
and rowid <600000;

create table BenefitsCostSharing2016_v6 as
select * from BenefitsCostSharing2016 bcs
where rowid >= 600000
and rowid <700000;

create table BenefitsCostSharing2016_v7 as
select * from BenefitsCostSharing2016 bcs
where rowid >= 700000
and rowid <800000;

create table BenefitsCostSharing2016_v8 as
select * from BenefitsCostSharing2016 bcs
where rowid >= 800000
and rowid <900000;

create table BenefitsCostSharing2016_v9 as
select * from BenefitsCostSharing2016 bcs
where rowid >= 900000
and rowid <1000000;

create table BenefitsCostSharing2016_v10 as
select * from BenefitsCostSharing2016 bcs
where rowid >= 1000000
and rowid <1100000;

create table BenefitsCostSharing2016_v11 as
select * from BenefitsCostSharing2016 bcs
where rowid >= 1100000
and rowid <1200000;

create table BenefitsCostSharing2016_v12 as
select * from BenefitsCostSharing2016 bcs
where rowid >= 1200000
and rowid <1300000;

create table BenefitsCostSharing2016_v13 as
select * from BenefitsCostSharing2016 bcs
where rowid >= 1300000
and rowid <1400000;

create table BenefitsCostSharing2016_v14 as
select * from BenefitsCostSharing2016 bcs
where rowid >= 1400000
and rowid <1500000;

create table BenefitsCostSharing2016_v15 as
select * from BenefitsCostSharing2016 bcs
where rowid >= 1500000
and rowid <1600000;

create table BenefitsCostSharing2016_v16 as
select * from BenefitsCostSharing2016 bcs
where rowid >= 1600000
and rowid <1700000;

create table BenefitsCostSharing2016_v17 as
select * from BenefitsCostSharing2016 bcs
where rowid >= 1700000
and rowid <1800000;

create table BenefitsCostSharing2016_v18 as
select * from BenefitsCostSharing2016 bcs
where rowid >= 1800000
and rowid <1900000;

select * from BenefitsCostSharing2016_v2;
select * from BenefitsCostSharing2016_v3;
select * from BenefitsCostSharing2016_v4;
select * from BenefitsCostSharing2016_v5;
select * from BenefitsCostSharing2016_v6;
select * from BenefitsCostSharing2016_v7;
select * from BenefitsCostSharing2016_v8;
select * from BenefitsCostSharing2016_v9;
select * from BenefitsCostSharing2016_v10;
select * from BenefitsCostSharing2016_v11;
select * from BenefitsCostSharing2016_v12;
select * from BenefitsCostSharing2016_v13;
select * from BenefitsCostSharing2016_v14;
select * from BenefitsCostSharing2016_v15;
select * from BenefitsCostSharing2016_v16;
select * from BenefitsCostSharing2016_v17;
select * from BenefitsCostSharing2016_v18;
drop table BenefitsCostSharing2016_v2;
drop table BenefitsCostSharing2016_v3;
drop table BenefitsCostSharing2016_v4;
drop table BenefitsCostSharing2016_v5;
drop table BenefitsCostSharing2016_v6;
drop table BenefitsCostSharing2016_v7;
drop table BenefitsCostSharing2016_v8;
drop table BenefitsCostSharing2016_v9;
drop table BenefitsCostSharing2016_v10;
drop table BenefitsCostSharing2016_v11;
drop table BenefitsCostSharing2016_v12;
drop table BenefitsCostSharing2016_v13;

create table BusinessRules2016 as
select * from BusinessRules br
where br.BusinessYear = 2016;

select * from BusinessRules2016;

create table Network2016 as
select * from Network n 
where BusinessYear = 2016;

select * from Network2016 n; 


create table PlanAttributes2016 as
select * from PlanAttributes pa 
where BusinessYear = 2016;

select * from PlanAttributes2016 n; 

create table Rate2016 as
select * from Rate r 
join (select PlanId, RateExpirationDate, min(r1.RatingAreaId) RatingAreaIdzz from Rate r1 
			where r1.RateExpirationDate = "2016-12-31"
			group by PlanId, RateExpirationDate) zz
		on r.PlanId = zz.PlanId
where r.BusinessYear = 2016
and r.RateExpirationDate = "2016-12-31"
and r.RatingAreaId=  zz.RatingAreaIdzz
and zz.PlanId=r.PlanId
--and r.PlanId = '21989AK0080001';

select max(rowid) from Rate2016; -- 374067

create table Rate2016_v1 as
select * from Rate2016
where rowid<190000;

create table Rate2016_v2 as
select * from Rate2016
where rowid>=190000;

select * from Rate2016_v1;
select * from Rate2016_v2;


create table ServiceArea2016 as
select * from ServiceArea pa 
where BusinessYear = 2016;

select * from ServiceArea2016 sa;

