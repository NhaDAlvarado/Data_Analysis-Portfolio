-- 2. MAGNITUDE ANALYSIS
-- Total provider by state
select provider_state,
      count(distinct provider_name) as provider_cnt
from `bigquery-public-data.cms_medicare.inpatient_charges_2015`
group by provider_state;

-- Total drugs provided by provider
select provider_name, count(distinct drg_definition)
from `bigquery-public-data.cms_medicare.inpatient_charges_2015`
group by provider_name;

-- Total discharges fro each drug 
select drg_definition,
  sum(total_discharges) as total_discharges
from `bigquery-public-data.cms_medicare.inpatient_charges_2015`
group by drg_definition;

-- Total hospital bills & avg charge for each provider
select provider_name,
  sum(average_covered_charges) as total_bill,
  round(avg(average_covered_charges),2) as avg_charge
from `bigquery-public-data.cms_medicare.inpatient_charges_2015`
group by provider_name;


