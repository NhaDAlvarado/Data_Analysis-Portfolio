-- EDA 
-- How many facility in the dataset
select count(distinct facility_name) as num_facilities
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`;

-- Explore all states 
select count(distinct state) as num_states
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`;

select distinct state
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`;

-- Explore total patitens from all nursing facility
select sum(distinct_beneficiaries_per_provider)
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`;

-- Explore total stays all over facilities 
select sum(total_stays)
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`;

-- Explore avg stay days all over facility
select round(avg(total_stays),2) as avg_stay
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`;

-- Explore avg snf chrage amount all over facility
select round(avg(total_snf_charge_amount),2)
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`;

-- Explore avg snf medicare allowed amount all over facility
select round(avg(total_snf_medicare_allowed_amount),2)
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`;

-- Explore avg snf medicare payment amount all over facility
select round(avg(total_snf_medicare_payment_amount),2)
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`;

-- Explore avg snf medicare standard payment amount all over facility
select round(avg(total_snf_medicare_standard_payment_amount),2)
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`;

-- Explore min and max age
select min(average_age), max(average_age)
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`;

-- Explore male, female percentage
select round(100.0*sum(male_beneficiaries)
              /sum(distinct_beneficiaries_per_provider)
            ,2) as male_pct,
      round(100.0*sum(female_beneficiaries)
              /sum(distinct_beneficiaries_per_provider)
            ,2) as female_pct
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`;

-- Explore dual, nondual percentage
select round(100.0*sum(nondual_beneficiaries)
              /sum(distinct_beneficiaries_per_provider)
            ,2) as nondual_pct,
      round(100.0*sum(dual_beneficiaries)
              /sum(distinct_beneficiaries_per_provider)
            ,2) as dual_pct
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`;

-- Explore avg hcc score all over facilities
select avg(average_hcc_score) as avg_hcc
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`;

select avg(average_hcc_score) as avg_hcc
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`;

select 
      'atrial_fibrillation' as mesurementname,
      sum(percent_of_beneficiaries_with_atrial_fibrillation*distinct_beneficiaries_per_provider) as atrial_fibrillation
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`
union all
select
      sum(percent_of_beneficiaries_with_alzheimers*distinct_beneficiaries_per_provider) as alzheimers
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`
union all
      sum(percent_of_beneficiaries_with_asthma*distinct_beneficiaries_per_provider) as asthma
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`
union all
select
      sum(percent_of_beneficiaries_with_cancer*distinct_beneficiaries_per_provider) as cancer
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`
union all
select
      sum(percent_of_beneficiaries_with_chf*distinct_beneficiaries_per_provider) as chf
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`
union all
select
      sum(percent_of_beneficiaries_with_chronic_kidney_disease*distinct_beneficiaries_per_provider) as chronic_kidney_disease
      from `bigquery-public-data.cms_medicare.nursing_facilities_2014`
union all
select
      sum(percent_of_beneficiaries_with_copd*distinct_beneficiaries_per_provider) as copd
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`
union all
select
      sum(percent_of_beneficiaries_with_depression*distinct_beneficiaries_per_provider) as depression
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`
union all
select
      sum(percent_of_beneficiaries_with_diabetes*distinct_beneficiaries_per_provider) as diabetes
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`
union all
select
      sum(percent_of_beneficiaries_with_hyperlipidemia*distinct_beneficiaries_per_provider) as hyperlipidemia
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`
union all
select
      sum(percent_of_beneficiaries_with_hypertension*distinct_beneficiaries_per_provider) as hypertension
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`
union all
select
      sum(percent_of_beneficiaries_with_ihd*distinct_beneficiaries_per_provider) as ihd
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`
union all
select
      sum(percent_of_beneficiaries_with_osteoporosis*distinct_beneficiaries_per_provider) as osteoporosis
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`
union all
select
      sum(percent_of_beneficiaries_with_ra_oa*distinct_beneficiaries_per_provider) as ra_oa
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`
union all
select
      sum(percent_of_beneficiaries_with_schizophrenia*distinct_beneficiaries_per_provider) as schizophrenia
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`
union all
select
      sum(percent_of_beneficiaries_with_stroke*distinct_beneficiaries_per_provider) as stroke
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`


