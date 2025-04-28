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
select state, 
      round(
            sum(total_snf_medicare_payment_amount)
            /count(distinct provider_id)
      ,2) as medicare_payment_per_facility
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`
group by state
order by medicare_payment_per_facility
limit 1;

-- Which facilities receive the highest Medicare allowed amount relative to SNF charges?
select provider_id, 
      round(
            sum(total_snf_medicare_allowed_amount)
            /sum(total_snf_charge_amount)
      ,2) as ratio
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`
group by provider_id 
order by ratio desc 
limit 1;

-- CUMULATIVE ANALYSIS
-- What is the cumulative total of total_snf_charge_amount by state, ordered by the highest charging facilities within each state?
select facility_name,
      state,
      total_snf_charge_amount,
      sum(total_snf_charge_amount) over (
            partition by state order by total_snf_charge_amount desc 
      ) as cum_total
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`;

-- How does the cumulative Medicare payment grow across all facilities when sorted by average HCC score descending?
select facility_name,
      average_hcc_score,
      total_snf_medicare_payment_amount,
      sum(total_snf_medicare_payment_amount) over ( order by average_hcc_score desc) as cum_total
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`;

-- For each state, what is the cumulative total of dual beneficiaries across facilities, ordered by facility name?
select facility_name,
      state,
      dual_beneficiaries,
      sum(dual_beneficiaries) over (
            partition by state order by facility_name
      ) as cum_total
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`;

-- What is the cumulative number of total stays across all providers, ordered by the number of stays descending?
select facility_name,
      total_stays,
      sum(total_stays) over (order by total_stays desc) as cum_total
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`;

-- How does the cumulative count of facilities with percent_of_beneficiaries_with_diabetes greater than a certain threshold grow by state?
with state_pct_beneficiaries_w_diabetes as (
      select state, 
            facility_name, 
            percent_of_beneficiaries_with_diabetes,
            avg(percent_of_beneficiaries_with_diabetes) over (partition by state) as avg_beneficiaries_w_diabetes
      from `bigquery-public-data.cms_medicare.nursing_facilities_2014`
),
compare_to_theshold as (
      select  n.state, 
            n.facility_name, 
            n.percent_of_beneficiaries_with_diabetes,
            d.avg_beneficiaries_w_diabetes
      from `bigquery-public-data.cms_medicare.nursing_facilities_2014` as n 
      join state_pct_beneficiaries_w_diabetes as d 
      on n.state = d.state
      and n.facility_name = d.facility_name
      where n.percent_of_beneficiaries_with_diabetes >d.avg_beneficiaries_w_diabetes
)
select state,
      count(facility_name) as facility_w_pct_greater_than_avg
from compare_to_theshold
group by state;

-- Within each city, what is the running total of total_snf_medicare_allowed_amount when facilities are ordered by average age of beneficiaries?
select city, 
      facility_name,
      average_age,
      total_snf_medicare_allowed_amount,
      sum(total_snf_medicare_allowed_amount) over (
            partition by city order by average_age
      ) as running_sum
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`;

-- What is the cumulative number of white beneficiaries by state, ordered by the number of white beneficiaries per facility descending?
select facility_name,
      state,
      white_beneficiaries,
      sum(white_beneficiaries) over (
            partition by state order by white_beneficiaries desc
      ) as cum_total
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`;

-- What is the cumulative percentage of beneficiaries with hypertension across all facilities, ordered by provider_id?
select facility_name,
      percent_of_beneficiaries_with_hypertension,
      sum(percent_of_beneficiaries_with_hypertension) over (
            order by provider_id desc
      ) as cum_total
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`
where percent_of_beneficiaries_with_hypertension is not null;

-- How does the cumulative total Medicare standard payment (total_snf_medicare_standard_payment_amount) vary by zip code, sorted by payment amount?
select facility_name,
      zip_code,
      total_snf_medicare_standard_payment_amount,
      sum(total_snf_medicare_standard_payment_amount) over (
            partition by zip_code 
            order by total_snf_medicare_standard_payment_amount desc
      ) as cum_total
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`;

-- For each disease condition (like Alzheimer’s or CHF), what is the cumulative number of affected beneficiaries across all facilities, sorted by the condition prevalence?
select facility_name,
      distinct_beneficiaries_per_provider,
      percent_of_beneficiaries_with_alzheimers,
      round(distinct_beneficiaries_per_provider*percent_of_beneficiaries_with_alzheimers/100.0) as num_beneficiaries_w_alzheimers,
      round(sum(distinct_beneficiaries_per_provider*percent_of_beneficiaries_with_alzheimers/100.0) over (
                  order by percent_of_beneficiaries_with_alzheimers desc
      )) as running_sum
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`;

-- What is the cumulative male vs. female beneficiary count across all states, ordered by state alphabetically?
select facility_name,
      state,
      male_beneficiaries,
      sum(male_beneficiaries) over (
            partition by state order by state 
      ) as cum_total_male_beneficiaries,
      female_beneficiaries,
      sum(female_beneficiaries) over (
            partition by state order by state 
      ) as cum_total_female_beneficiaries
from `bigquery-public-data.cms_medicare.nursing_facilities_2014`;

-- Within each state, what is the cumulative total of average lengths of stay (in days), sorted by descending average length?

-- How does the cumulative total charge amount vary with increasing average age across all facilities?

-- What is the cumulative number of Asian/Pacific Islander beneficiaries grouped by city, ordered by total number in descending order?

-- How does the cumulative number of dual beneficiaries increase by facility, ordered by percent of beneficiaries with depression?

