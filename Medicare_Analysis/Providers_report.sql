/*
===============================================================================
Report
===============================================================================
Purpose:
    - This report consolidates key metrics and behaviors.

Highlights:
    1. Gathers essential fields such as provider_id, name, address,
		state, and cost (2011-2015).
    2. Segments products by revenue to identify 'High Medicare Dependency', 
        Moderate Medicare Dependency, or Low Medicare Dependency.
    3. Aggregates product-level metrics:
       - total medicare cover
       - total hospital bill
===============================================================================
*/
drop view if exists providers_report;
create view providers_report as 
with yearly_info as (
  select '2015' as year,
        provider_id,
        provider_name,
        provider_state,
        provider_street_address,
        provider_zipcode,
        hospital_referral_region_description,
        sum(total_discharges) as ttl_discharges,
        round(sum(average_covered_charges * total_discharges) / sum(total_discharges)
                ,2) as avg_hospital_charged,
        round(sum(average_total_payments * total_discharges) / sum(total_discharges)
                ,2) as avg_patient_paid,
        round(sum(average_medicare_payments*total_discharges)/sum(total_discharges)
                ,2) as avg_medicare_covered,
        round( sum(average_medicare_payments * total_discharges) / sum(average_total_payments * total_discharges)
                ,2) as medicare_payment_ratio
  from `bigquery-public-data.cms_medicare.inpatient_charges_2015` 
  group by provider_id,
        provider_name,
        provider_state,
        provider_street_address,
        provider_zipcode,
        hospital_referral_region_description
  union all 
  select '2014' as year,
        provider_id,
        provider_name,
        provider_state,
        provider_street_address,
        provider_zipcode,
        hospital_referral_region_description,
        sum(total_discharges) as ttl_discharges,
        round(sum(average_covered_charges * total_discharges) / sum(total_discharges)
                ,2) as avg_hospital_charged,
        round(sum(average_total_payments * total_discharges) / sum(total_discharges)
                ,2) as avg_patient_paid,
        round(sum(average_medicare_payments*total_discharges)/sum(total_discharges)
                ,2) as avg_medicare_covered,
        round( sum(average_medicare_payments * total_discharges) / sum(average_total_payments * total_discharges)
                ,2) as medicare_payment_ratio
  from `bigquery-public-data.cms_medicare.inpatient_charges_2014` 
  group by provider_id,
        provider_name,
        provider_state,
        provider_street_address,
        provider_zipcode,
        hospital_referral_region_description
  union all 
  select '2013' as year,
          provider_id,
        provider_name,
        provider_state,
        provider_street_address,
        provider_zipcode,
        hospital_referral_region_description,
        sum(total_discharges) as ttl_discharges,
        round(sum(average_covered_charges * total_discharges) / sum(total_discharges)
                ,2) as avg_hospital_charged,
        round(sum(average_total_payments * total_discharges) / sum(total_discharges)
                ,2) as avg_patient_paid,
        round(sum(average_medicare_payments*total_discharges)/sum(total_discharges)
                ,2) as avg_medicare_covered,
        round( sum(average_medicare_payments * total_discharges) / sum(average_total_payments * total_discharges)
                ,2) as medicare_payment_ratio
  from `bigquery-public-data.cms_medicare.inpatient_charges_2013` 
  group by provider_id,
        provider_name,
        provider_state,
        provider_street_address,
        provider_zipcode,
        hospital_referral_region_description
  union all 
  select '2012' as year,
          provider_id,
        provider_name,
        provider_state,
        provider_street_address,
        provider_zipcode,
        hospital_referral_region_description,
        sum(total_discharges) as ttl_discharges,
        round(sum(average_covered_charges * total_discharges) / sum(total_discharges)
                ,2) as avg_hospital_charged,
        round(sum(average_total_payments * total_discharges) / sum(total_discharges)
                ,2) as avg_patient_paid,
        round(sum(average_medicare_payments*total_discharges)/sum(total_discharges)
                ,2) as avg_medicare_covered,
        round( sum(average_medicare_payments * total_discharges) / sum(average_total_payments * total_discharges)
                ,2) as medicare_payment_ratio
  from `bigquery-public-data.cms_medicare.inpatient_charges_2012` 
  group by provider_id,
        provider_name,
        provider_state,
        provider_street_address,
        provider_zipcode,
        hospital_referral_region_description
  union all 
  select '2011' as year,
        provider_id,
        provider_name,
        provider_state,
        provider_street_address,
        provider_zipcode,
        hospital_referral_region_description,
        sum(total_discharges) as ttl_discharges,
        round(sum(average_covered_charges * total_discharges) / sum(total_discharges)
                ,2) as avg_hospital_charged,
        round(sum(average_total_payments * total_discharges) / sum(total_discharges)
                ,2) as avg_patient_paid,
        round(sum(average_medicare_payments*total_discharges)/sum(total_discharges)
                ,2) as avg_medicare_covered,
        round( sum(average_medicare_payments * total_discharges) / sum(average_total_payments * total_discharges)
                ,2) as medicare_payment_ratio
  from `bigquery-public-data.cms_medicare.inpatient_charges_2011` 
  group by provider_id,
        provider_name,
        provider_state,
        provider_street_address,
        provider_zipcode,
        hospital_referral_region_description
)
select  year,
        provider_id,
        provider_name,
        provider_state,
        provider_street_address,
        provider_zipcode,
        hospital_referral_region_description,
        ttl_discharges,
        round(100.0*(
                ttl_discharges- lag(ttl_discharges) over (partition by provider_name order by year)) 
                /lag(ttl_discharges) over (partition by provider_name order by year) 
                ,2) as yoy_discharges,
        medicare_payment_ratio,
        case
                when medicare_payment_ratio > 0.8 then 'High Medicare Dependency'
                when medicare_payment_ratio > 0.5 then 'Moderate Medicare Dependency'
                else 'Low Medicare Dependency'
        end as medicare_segment,
        avg_hospital_charged, 
        round(100.0*(
                avg_hospital_charged- lag(avg_hospital_charged) over (partition by provider_name order by year)) 
                /lag(avg_hospital_charged) over (partition by provider_name order by year) 
                ,2) as yoy_hos_charged,
        avg_patient_paid, 
        round(100.0*(
                avg_patient_paid- lag(avg_patient_paid) over (partition by provider_name order by year)) 
                /lag(avg_patient_paid) over (partition by provider_name order by year) 
                ,2) as yoy_patient_paid,
        avg_medicare_covered,
        round(100.0*(
                avg_medicare_covered- lag(avg_medicare_covered) over (partition by provider_name order by year)) 
                /lag(avg_medicare_covered) over (partition by provider_name order by year) 
                ,2) as yoy_medicare_covered
from yearly_info;