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

-- compare drug discharge for each type of drug 2014 ans 2015
with drg_discharge_2015 as (
  select fi.drg_definition as drg_2015,
      sum(fi.total_discharges) as total_discharge_2015     
  from `bigquery-public-data.cms_medicare.inpatient_charges_2015` as fi
  full join `bigquery-public-data.cms_medicare.inpatient_charges_2014` as fo
  on fi.provider_name = fo.provider_city
  and fi.drg_definition = fo.drg_definition
  group by fi.drg_definition
),
drg_discharge_2014 as (
  select fo.drg_definition as drg_2014,
      sum(fo.total_discharges) as total_discharge_2014     
  from `bigquery-public-data.cms_medicare.inpatient_charges_2015` as fi
  full join `bigquery-public-data.cms_medicare.inpatient_charges_2014` as fo
  on fi.provider_name = fo.provider_city
  and fi.drg_definition = fo.drg_definition
  group by fo.drg_definition
),
combine_info as (
  select drg_2015, total_discharge_2015, drg_2014, total_discharge_2014 
  from drg_discharge_2015
  full join drg_discharge_2014
  on drg_2015 = drg_2014
)
select case 
          when drg_2015 is null then drg_2014 
          else drg_2015 
        end as drg_2015,
      case 
        when total_discharge_2015 is null then 0
        else total_discharge_2015 
      end as total_discharge_2015,
      case 
        when total_discharge_2014 is null then 0
        else total_discharge_2014 
      end as total_discharge_2014,
      case when total_discharge_2015 > total_discharge_2014 then 'increase'
          else 'decrease'
      end as comparison
from combine_info

