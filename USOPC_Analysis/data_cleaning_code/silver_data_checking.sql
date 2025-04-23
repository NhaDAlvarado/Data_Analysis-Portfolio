-- select * from gold.NGBHealthDataOutputExtract;
-- select * from gold.SportBenefitsStatementsDataByYear;

-- check if staff_bucket can give any info to fill in n/a value in staff_bucket_def
select distinct staff_bucket_def, staff_bucket
from silver.NGBHealthDataOutputExtract;

-- check if revenue_bucket can give any info to fill in n/a value in revenue_bucket_def
select distinct revenue_bucket_def, revenue_bucket
from silver.NGBHealthDataOutputExtract;

-- check if membership_bucket can give any info to fill in n/a value in membership_bucket_def
select distinct membership_bucket_def, membership_bucket
from silver.NGBHealthDataOutputExtract;

