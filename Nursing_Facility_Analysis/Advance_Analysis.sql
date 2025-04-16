--EDA 
-- How many facility in the dataset
select count(distinct facility_name) as num_facilities
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`;

-- Explore all states 
select count(distinct state) as num_states
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`;

select distinct state
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`;

-- MAGNITUDE ANALYSIS
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

-- Explore number of beneficiaries with each descease
select 
      'atrial_fibrillation' as measure_name,
      sum(percent_of_beneficiaries_with_atrial_fibrillation*distinct_beneficiaries_per_provider) as num_beneficiaries
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`
union all
select 
      'alzheimers' as measure_name,
      sum(percent_of_beneficiaries_with_alzheimers*distinct_beneficiaries_per_provider) as num_beneficiaries
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`
union all
select 
      'asthma' as measure_name,
      sum(percent_of_beneficiaries_with_asthma*distinct_beneficiaries_per_provider) as num_beneficiaries
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`
union all
select
      'cancer' as measure_name,
      sum(percent_of_beneficiaries_with_cancer*distinct_beneficiaries_per_provider) as num_beneficiaries
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`
union all
select
      'chf' as measure_name,
      sum(percent_of_beneficiaries_with_chf*distinct_beneficiaries_per_provider) as num_beneficiaries
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`
union all
select
      'chronic_kidney_disease' as measure_name,
      sum(percent_of_beneficiaries_with_chronic_kidney_disease*distinct_beneficiaries_per_provider) as num_beneficiaries
      from `bigquery-public-data.cms_medicare.nursing_facilities_2014`
union all
select
      'copd' as measure_name,
      sum(percent_of_beneficiaries_with_copd*distinct_beneficiaries_per_provider) as num_beneficiaries
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`
union all
select
      'depression' as measure_name,
      sum(percent_of_beneficiaries_with_depression*distinct_beneficiaries_per_provider) as num_beneficiaries
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`
union all
select
      'diabetes' as measure_name,
      sum(percent_of_beneficiaries_with_diabetes*distinct_beneficiaries_per_provider) as num_beneficiaries
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`
union all
select
      'hyperlipidemia' as measure_name,
      sum(percent_of_beneficiaries_with_hyperlipidemia*distinct_beneficiaries_per_provider) as num_beneficiaries
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`
union all
select
      'hypertension' as measure_name,
      sum(percent_of_beneficiaries_with_hypertension*distinct_beneficiaries_per_provider) as num_beneficiaries
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`
union all
select
      'ihd' as measure_name,
      sum(percent_of_beneficiaries_with_ihd*distinct_beneficiaries_per_provider) as num_beneficiaries
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`
union all
select
      'osteoporosis' as measure_name,
      sum(percent_of_beneficiaries_with_osteoporosis*distinct_beneficiaries_per_provider) as num_beneficiaries
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`
union all
select
      'ra_oa' as measure_name,
      sum(percent_of_beneficiaries_with_ra_oa*distinct_beneficiaries_per_provider) as num_beneficiaries
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`
union all
select
      'schizophrenia' as measure_name,
      sum(percent_of_beneficiaries_with_schizophrenia*distinct_beneficiaries_per_provider) as num_beneficiaries
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`
union all
select
      'stroke' as measure_name,
      sum(percent_of_beneficiaries_with_stroke*distinct_beneficiaries_per_provider) as num_beneficiaries
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`;

-- Total beneficiaries in state
select state,
      sum(distinct_beneficiaries_per_provider) as num_beneficiaries
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`
group by state;

-- What is the weighted average HCC score across all beneficiaries?
select 
      round(
        sum(average_hcc_score*distinct_beneficiaries_per_provider)
        /sum(distinct_beneficiaries_per_provider) 
      ,2) as weighted_avg_hcc
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`;

-- How many facilities are for-profit, non-profit, or government-owned?
with extract_info as (
  select n.provider_id, n.state, h.hospital_ownership
  from `bigquery-public-data.cms_medicare.nursing_facilities_2014` as n 
  left join `bigquery-public-data.cms_medicare.hospital_general_info` as h
  on n.provider_id = h.provider_id 
)
select 
      case 
          when hospital_ownership in ('Proprietary', 'Physician') then 'For-Profit'
          when hospital_ownership in ('Voluntary non-profit - Private', 
                                      'Voluntary non-profit - Other', 
                                      'Voluntary non-profit - Church') then 'Non-Profit'
          when hospital_ownership in ('Government - Hospital District or Authority', 
                                      'Government - Local', 
                                      'Government - State') then 'Goverment'   
          else 'N/A'
      end as facilities_category,
      count(distinct provider_id) as num_facility                   
from extract_info
group by facilities_category;

-- RANKING ANALYSIS
-- What are the top 10 nursing facilities by number of distinct beneficiaries served?
select provider_id, 
      sum(distinct_beneficiaries_per_provider) as total_beneficiaries
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`
group by provider_id
order by total_beneficiaries desc
limit 10;

-- Which providers have the highest average HCC risk scores?
select provider_id, 
      avg(average_hcc_score) as avg_hcc
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`
group by provider_id
order by avg_hcc desc;

-- Who are the top 10 providers in terms of total SNF charges?
select provider_id, 
      sum(total_snf_charge_amount) as total_snf_charge
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`
group by provider_id
order by total_snf_charge desc
limit 1;

-- Which providers receive the most standardized Medicare payments?
select provider_id, 
      sum(total_snf_medicare_standard_payment_amount) as total_standardize_medicare 
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`
group by provider_id
order by total_standardize_medicare desc
limit 1;

-- Which states have the highest total Medicare payment amount?
select state, 
      sum(total_snf_medicare_payment_amount) as total_medicare_amount 
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`
group by state
order by total_medicare_amount  desc
limit 1;

-- What ZIP codes rank highest in total SNF Medicare charges?
select zip_code, 
      sum(total_snf_charge_amount) as total_snf_amount 
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`
group by zip_code
order by total_snf_amount desc
limit 1;

-- Which counties have the most dual-eligible beneficiaries treated?
select state, 
      sum(dual_beneficiaries) as total_dual_beneficiaries 
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`
group by state
order by total_dual_beneficiaries desc
limit 1;

-- What states have the highest average HCC score?
select state, 
      round(avg(average_hcc_score),2) as avg_hcc_score
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`
group by state
order by avg_hcc_score desc
limit 1;

-- Which providers have the highest Medicare payment per beneficiary?
select provider_id, 
      round(
            sum(total_snf_medicare_payment_amount)
            /sum(distinct_beneficiaries_per_provider)
      ,2) as medicare_payment_per_beneficiary
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`
group by provider_id
order by medicare_payment_per_beneficiary desc
limit 1;

-- Which states have the lowest average Medicare payment per facility?
-- Which facilities receive the highest Medicare allowed amount relative to SNF charges?
