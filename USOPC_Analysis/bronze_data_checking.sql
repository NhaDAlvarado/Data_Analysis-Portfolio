select *
from bronze.SportBenefitsStatementsDataByYear;

select *
from bronze.NGBHealthDataOutputExtract;

-- Check if ngb from SportBenefitsStatementsDataByYear match NGBHealthDataOutputExtract
select distinct ngb, overall_parent_ngb
from bronze.SportBenefitsStatementsDataByYear as s
left join bronze.NGBHealthDataOutputExtract as h
on s.ngb = h.overall_parent_ngb
where h.overall_parent_ngb is null
order by ngb;

-- check financial year from NGBHealthDataOutputExtract
select distinct financial_year
from bronze.NGBHealthDataOutputExtract;

-- check membership bucket def from NGBHealthDataOutputExtract
select distinct membership_bucket_def
from bronze.NGBHealthDataOutputExtract

