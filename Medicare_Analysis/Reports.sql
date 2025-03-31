/*
===============================================================================
Report
===============================================================================
Purpose:
    - This report consolidates key metrics and behaviors.

Highlights:
    1. Gathers essential fields such as drg_definitions, state, and cost (2011-2015).
    2. Segments products by revenue to identify 'High Medicare Dependency', 
        Moderate Medicare Dependency, or Low Medicare Dependency.
    3. Aggregates product-level metrics:
       - total medicare cover
       - total hospital bill
===============================================================================
*/

with yearly_info as (
  select '2015' as year,
        drg_definition, 
        sum(total_discharges) as ttl_discharges,
        sum(average_covered_charges) as ttl_hospital_charged, 
        sum(average_total_payments) as ttl_patient_paid,
        sum(average_medicare_payments) as ttl_medicare_covered
  from `bigquery-public-data.cms_medicare.inpatient_charges_2015` 
  group by drg_definition
  union all 
  select '2014' as year,
        drg_definition, 
        sum(total_discharges) as ttl_discharges,
        sum(average_covered_charges) as ttl_hospital_charged, 
        sum(average_total_payments) as ttl_patient_paid,
        sum(average_medicare_payments) as ttl_medicare_covered
  from `bigquery-public-data.cms_medicare.inpatient_charges_2014` 
  group by drg_definition
  union all 
  select '2013' as year,
          drg_definition, 
        sum(total_discharges) as ttl_discharges,
        sum(average_covered_charges) as ttl_hospital_charged, 
        sum(average_total_payments) as ttl_patient_paid,
        sum(average_medicare_payments) as ttl_medicare_covered
  from `bigquery-public-data.cms_medicare.inpatient_charges_2013` 
  group by drg_definition
  union all 
  select '2012' as year,
          drg_definition, 
        sum(total_discharges) as ttl_discharges,
        sum(average_covered_charges) as ttl_hospital_charged, 
        sum(average_total_payments) as ttl_patient_paid,
        sum(average_medicare_payments) as ttl_medicare_covered
  from `bigquery-public-data.cms_medicare.inpatient_charges_2012` 
  group by drg_definition
  union all 
  select '2011' as year,
          drg_definition, 
        sum(total_discharges) as ttl_discharges,
        sum(average_covered_charges) as ttl_hospital_charged, 
        sum(average_total_payments) as ttl_patient_paid,
        sum(average_medicare_payments) as ttl_medicare_covered
  from `bigquery-public-data.cms_medicare.inpatient_charges_2011` 
  group by drg_definition
)
select year, 
        drg_definition, 
        ttl_discharges,
        ttl_hospital_charged, 
        ttl_patient_paid, 
        ttl_medicare_covered
from yearly_info