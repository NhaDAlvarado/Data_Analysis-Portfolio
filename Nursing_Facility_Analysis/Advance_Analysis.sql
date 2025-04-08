-- EDA
-- How many facility in the dataset
select count(distinct facility_name) as num_facilities
from `bigquery-public-data.cms_medicare.nursing_facilities_2013`;

-- Explore all states 
select count(distinct state) as num_states
from `bigquery-public-data.cms_medicare.nursing_facilities_2013`;

select distinct state
from `bigquery-public-data.cms_medicare.nursing_facilities_2013`;

-- Explore total patitens from all nursing facility
select sum(distinct_beneficiaries_per_provider)
from `bigquery-public-data.cms_medicare.nursing_facilities_2013`;