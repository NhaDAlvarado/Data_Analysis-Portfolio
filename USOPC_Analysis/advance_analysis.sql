-- select * from gold.NGBHealthDataOutputExtract;
-- select * from gold.SportBenefitsStatementsDataByYear;

-- EDA
select distinct staff_bucket_def
from gold.NGBHealthDataOutputExtract;

select distinct revenue_bucket_def
from gold.NGBHealthDataOutputExtract;

select distinct membership_bucket_def, membership_bucket
from gold.NGBHealthDataOutputExtract