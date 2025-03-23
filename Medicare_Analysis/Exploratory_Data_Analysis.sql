-- 1. Exploratory Data Analysis (EDA)
-- What tables are available in the dataset, and what are their structures?
select table_name
from `bigquery-public-data.cms_medicare.INFORMATION_SCHEMA.TABLES`;

-- Explore all columns in the database
select * 
from `bigquery-public-data.cms_medicare.INFORMATION_SCHEMA.COLUMNS`
where table_name = 'inpatient_charges_2015';

-- Explore all provider name
select distinct provider_name 
from `bigquery-public-data.cms_medicare.inpatient_charges_2015`;

-- Explore state where provider locate
select distinct provider_state
from `bigquery-public-data.cms_medicare.inpatient_charges_2015`;

-- Explore drug code
select distinct drg_definition
from `bigquery-public-data.cms_medicare.inpatient_charges_2015`;

-- Explore total discharges 
select sum(total_discharges) as total_discharges
from `bigquery-public-data.cms_medicare.inpatient_charges_2015`;

-- Explore total out of pocket and medicare cover
select sum(average_total_payments) as out_of_pockets,
      sum(average_medicare_payments) as medicare_cover
from `bigquery-public-data.cms_medicare.inpatient_charges_2015`;

-- Generate a report that show all key metrics of business
select 'Total Hopital Bill' as measure_name, sum(average_covered_charges) from `bigquery-public-data.cms_medicare.inpatient_charges_2015`
union all
select 'Total Out of Pockets' as measure_name, sum(average_total_payments) from `bigquery-public-data.cms_medicare.inpatient_charges_2015`
union all
select 'Total Medicare Cover' as measure_name, sum(average_medicare_payments) from `bigquery-public-data.cms_medicare.inpatient_charges_2015`
union all
select 'Total Drug Discharge' as measure_name, sum(total_discharges) from `bigquery-public-data.cms_medicare.inpatient_charges_2015`;

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


