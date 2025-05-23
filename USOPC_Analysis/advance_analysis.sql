-- MAGNITUDE ANALYSIS
-- Which NGBs received the highest and lowest total funding amounts from USOPC in 2020?
select ngb,
	round( sum(Athlete_360
		+ Athlete_Stipends
		+ Coaching_Education
		+ COVID_Athlete_Assistance_Fund
		+ Elite_Athlete_Health_Insurance
		+ High_Performance_Grants
		+ High_Performance_Special_Grants
		+ National_Medical_Network
		+ NGB_HPMO_COVID_Grants
		+ Operation_Gold
		+ Paralympic_Sport_Development_Grants
		+ Restricted_Grants
		+ Sport_Science_Services
		+ Sports_Medicine_Clinics
		+ Facilities_Chula_Vista_California
		+ Facilities_Colorado_Springs_Colorado
		+ Facilities_Lake_Placid_New_York
		+ Facilities_Salt_Lake_City_Utah
	)::numeric,2) as total_funding
from gold.SportBenefitsStatementsDataByYear
where year = 2020
group by ngb
order by total_funding; 

-- What is the dollar value range (min/max/avg) for athlete_stipends across all NGBs in 2019-2020?
select min(athlete_stipends) as min,
	max(athlete_stipends) as max,
	round(avg(athlete_stipends)::numeric,2) as avg
from gold.SportBenefitsStatementsDataByYear;

-- RANKING ANALYSIS
-- Rank NGBs by percentage of total funding allocated to athlete direct support (athlete_360 + athlete_stipends) in 2020.
select ngb,
	round(100.0
		*sum(athlete_360 + athlete_stipends)::numeric
		/sum(Athlete_360
			+ Athlete_Stipends
			+ Coaching_Education
			+ COVID_Athlete_Assistance_Fund
			+ Elite_Athlete_Health_Insurance
			+ High_Performance_Grants
			+ High_Performance_Special_Grants
			+ National_Medical_Network
			+ NGB_HPMO_COVID_Grants
			+ Operation_Gold
			+ Paralympic_Sport_Development_Grants
			+ Restricted_Grants
			+ Sport_Science_Services
			+ Sports_Medicine_Clinics
			+ Facilities_Chula_Vista_California
			+ Facilities_Colorado_Springs_Colorado
			+ Facilities_Lake_Placid_New_York
			+ Facilities_Salt_Lake_City_Utah
		)::numeric,2) as percentage
from gold.SportBenefitsStatementsDataByYear
where year = 2020
group by ngb
order by percentage desc;

-- Which 5 NGBs showed the largest disparity between high_performance_grants and coaching_education funding?
select ngb,
    high_performance_grants,
    coaching_education,
	case when coaching_education = 0  then null
		else (high_performance_grants/coaching_education)
	end as disparity
from gold.SportBenefitsStatementsDataByYear
where year = 2020 and coaching_education !=0
order by disparity desc
limit 5;

-- CHANGE OVER TIME ANALYSIS
-- Which NGBs had the most significant increases/decreases (>25%) in operation_gold funding between 2019-2020?
with cal_prv_operation_gold as (
	select year, ngb, 
		lag(operation_gold) over (partition by ngb order by year) as prv_operation_gold,
		operation_gold
	from gold.SportBenefitsStatementsDataByYear
)
select ngb,
	100.0*(operation_gold - prv_operation_gold)/ nullif(prv_operation_gold,0) as yoy_change_pct,
	case 
        when (operation_gold - prv_operation_gold) / nullif(prv_operation_gold, 0) > 0.25 then 'Significant Increase (>25%)'
        when (operation_gold - prv_operation_gold) / nullif(prv_operation_gold, 0) < -0.25 then 'Significant Decrease (>25%)'
       	else 'Within Normal Range'
    end as change_category
from cal_prv_operation_gold
where prv_operation_gold is not null and prv_operation_gold != 0;

-- How did the proportion of paralympic_sport_development_grants change year-over-year for Paralympic sports?
with cal_total_grants as (
	select year,
		olympic_paralympic_panamerican,
		sum(paralympic_sport_development_grants) as total_grants
	from gold.SportBenefitsStatementsDataByYear
	group by olympic_paralympic_panamerican, year
),
cal_prv_total_grants as (
	select year,
		olympic_paralympic_panamerican,
		lag(total_grants) over (partition by olympic_paralympic_panamerican order by year) as total_grants_2019,
		total_grants as total_grants_2020
	from cal_total_grants
)
select olympic_paralympic_panamerican,
	100.0*(total_grants_2020 - total_grants_2019)/nullif(total_grants_2019,0) as yoy_change_pct
from cal_prv_total_grants
where total_grants_2019 is not null;

-- CUMULATIVE ANALYSIS
-- What percentage of total USOPC funding went to the top 10 NGBs by funding amount in 2020?
with total_usopc_funding as (
	select 
		round( sum(Athlete_360
			+ Athlete_Stipends
			+ Coaching_Education
			+ COVID_Athlete_Assistance_Fund
			+ Elite_Athlete_Health_Insurance
			+ High_Performance_Grants
			+ High_Performance_Special_Grants
			+ National_Medical_Network
			+ NGB_HPMO_COVID_Grants
			+ Operation_Gold
			+ Paralympic_Sport_Development_Grants
			+ Restricted_Grants
			+ Sport_Science_Services
			+ Sports_Medicine_Clinics
			+ Facilities_Chula_Vista_California
			+ Facilities_Colorado_Springs_Colorado
			+ Facilities_Lake_Placid_New_York
			+ Facilities_Salt_Lake_City_Utah
		)::numeric,2) as total_USOPC_funding
	from gold.SportBenefitsStatementsDataByYear
	where year = 2020
),
top_10_ngb as (
	select ngb,
		round( sum(Athlete_360
			+ Athlete_Stipends
			+ Coaching_Education
			+ COVID_Athlete_Assistance_Fund
			+ Elite_Athlete_Health_Insurance
			+ High_Performance_Grants
			+ High_Performance_Special_Grants
			+ National_Medical_Network
			+ NGB_HPMO_COVID_Grants
			+ Operation_Gold
			+ Paralympic_Sport_Development_Grants
			+ Restricted_Grants
			+ Sport_Science_Services
			+ Sports_Medicine_Clinics
			+ Facilities_Chula_Vista_California
			+ Facilities_Colorado_Springs_Colorado
			+ Facilities_Lake_Placid_New_York
			+ Facilities_Salt_Lake_City_Utah
		)::numeric,2) as total_funding_by_ngb
	from gold.SportBenefitsStatementsDataByYear
	where year = 2020
	group by ngb
	order by total_funding_by_ngb desc
	limit 10
),
cal_top_10_funding as (
	select sum(total_funding_by_ngb) as total_funding_in_top_10
	from top_10_ngb
)
select round(100.0*total_funding_in_top_10/total_USOPC_funding,2) as pct
from cal_top_10_funding
cross join total_usopc_funding;

-- Calculate the running total of high_performance_grants by sport type (Olympic/Paralympic/PanAm) across both years.
with cal_high_performance_grants_by_type as (
	select olympic_paralympic_panamerican,
		sum(high_performance_grants) as total_high_performance_grants
	from gold.SportBenefitsStatementsDataByYear
	group by olympic_paralympic_panamerican
)
select olympic_paralympic_panamerican,
	total_high_performance_grants,
	sum(total_high_performance_grants) over (order by total_high_performance_grants desc) as running_sum
from cal_high_performance_grants_by_type;

-- PERFORMANCE ANALYSIS
-- Which NGBs with membership_size >10,000 had the highest funding per member (total funding/membership_size)?
with extract_info as (
	select ngb,
		round(avg(membership_size)::numeric,2) as avg_membership_size,
		round( sum(Athlete_360
				+ Athlete_Stipends
				+ Coaching_Education
				+ COVID_Athlete_Assistance_Fund
				+ Elite_Athlete_Health_Insurance
				+ High_Performance_Grants
				+ High_Performance_Special_Grants
				+ National_Medical_Network
				+ NGB_HPMO_COVID_Grants
				+ Operation_Gold
				+ Paralympic_Sport_Development_Grants
				+ Restricted_Grants
				+ Sport_Science_Services
				+ Sports_Medicine_Clinics
				+ Facilities_Chula_Vista_California
				+ Facilities_Colorado_Springs_Colorado
				+ Facilities_Lake_Placid_New_York
				+ Facilities_Salt_Lake_City_Utah
			)::numeric,2) as total_funding_by_ngb
	from gold.SportBenefitsStatementsDataByYear as s
	join gold.NGBHealthDataOutputExtract as d 
	on s.ngb = d.overall_parent_ngb
	group by ngb
)
select ngb, 
	avg_membership_size,
	total_funding_by_ngb,
	round(total_funding_by_ngb/avg_membership_size,2) as funding_per_member
from extract_info
where avg_membership_size >10000
order by funding_per_member desc;

-- Compare funding efficiency (total_expenses/total_funding) between NGBs with staff_size <10 vs >100.
with extract_info as (
	select overall_parent_ngb,
		staff_bucket_def,
		round(avg(total_expenses)::numeric,2) as avg_expenses,
		round( sum(Athlete_360
					+ Athlete_Stipends
					+ Coaching_Education
					+ COVID_Athlete_Assistance_Fund
					+ Elite_Athlete_Health_Insurance
					+ High_Performance_Grants
					+ High_Performance_Special_Grants
					+ National_Medical_Network
					+ NGB_HPMO_COVID_Grants
					+ Operation_Gold
					+ Paralympic_Sport_Development_Grants
					+ Restricted_Grants
					+ Sport_Science_Services
					+ Sports_Medicine_Clinics
					+ Facilities_Chula_Vista_California
					+ Facilities_Colorado_Springs_Colorado
					+ Facilities_Lake_Placid_New_York
					+ Facilities_Salt_Lake_City_Utah
				)::numeric,2) as total_funding
	from gold.NGBHealthDataOutputExtract as d 
	join gold.SportBenefitsStatementsDataByYear as s
	on s.ngb = d.overall_parent_ngb
	where staff_bucket_def = '< 10'
		or staff_bucket_def = '> 100'
	group by overall_parent_ngb, staff_bucket_def
)
select staff_bucket_def,
		round(sum(avg_expenses)/sum(total_funding),2) as funding_efficiency
from extract_info 
group by staff_bucket_def;

-- PART-TO-WHOLE ANALYSIS
-- What percentage of each NGB's total funding came from restricted_grants in 2020?
with extract_info as (
	select ngb,
		sum(restricted_grants) as restricted_grants,
		round( sum(Athlete_360
						+ Athlete_Stipends
						+ Coaching_Education
						+ COVID_Athlete_Assistance_Fund
						+ Elite_Athlete_Health_Insurance
						+ High_Performance_Grants
						+ High_Performance_Special_Grants
						+ National_Medical_Network
						+ NGB_HPMO_COVID_Grants
						+ Operation_Gold
						+ Paralympic_Sport_Development_Grants
						+ Restricted_Grants
						+ Sport_Science_Services
						+ Sports_Medicine_Clinics
						+ Facilities_Chula_Vista_California
						+ Facilities_Colorado_Springs_Colorado
						+ Facilities_Lake_Placid_New_York
						+ Facilities_Salt_Lake_City_Utah
					)::numeric,2) as total_funding
	from gold.SportBenefitsStatementsDataByYear
	where year =2020 
	group by ngb
)
select ngb,
	round(100.0*restricted_grants::numeric/nullif(total_funding,0)::numeric,2) as pct
from extract_info;

-- Break down the composition of funding (athlete support vs. facilities) for Olympic vs Paralympic NGBs.
with extract_info as (
	select olympic_paralympic_panamerican,
		round(sum(Athlete_360
					+ Athlete_Stipends
					+ Coaching_Education
					+ COVID_Athlete_Assistance_Fund
				)::numeric,2) as athlete_support_funding,
		round(sum(Facilities_Chula_Vista_California
			+ Facilities_Colorado_Springs_Colorado
			+ Facilities_Lake_Placid_New_York
			+ Facilities_Salt_Lake_City_Utah
			)::numeric,2) as facilities_funding,
		round( sum(Athlete_360
					+ Athlete_Stipends
					+ Coaching_Education
					+ COVID_Athlete_Assistance_Fund
					+ Elite_Athlete_Health_Insurance
					+ High_Performance_Grants
					+ High_Performance_Special_Grants
					+ National_Medical_Network
					+ NGB_HPMO_COVID_Grants
					+ Operation_Gold
					+ Paralympic_Sport_Development_Grants
					+ Restricted_Grants
					+ Sport_Science_Services
					+ Sports_Medicine_Clinics
					+ Facilities_Chula_Vista_California
					+ Facilities_Colorado_Springs_Colorado
					+ Facilities_Lake_Placid_New_York
					+ Facilities_Salt_Lake_City_Utah
				)::numeric,2) as total_funding
	from gold.SportBenefitsStatementsDataByYear
	group by olympic_paralympic_panamerican
)
select olympic_paralympic_panamerican,
		round(100.0*athlete_support_funding/total_funding,2) as athlete_support_funding_pct,
		round(100.0*facilities_funding/total_funding,2) as facilities_funding_pct
from extract_info;

-- DATA SEGMENTATION
-- Segment NGBs into quartiles based on total_revenue and compare their average athlete_stipends.
with revenue_quartiles as (
  select overall_parent_ngb,
    total_revenue,
	membership_size,
    ntile(4) over (order by total_revenue desc) as revenue_quartile
  from gold.NGBHealthDataOutputExtract
  where overall_year = 2019 -- that's mean year = 2020 in SportBenefitsStatementsDataByYear table
)
select
  r.revenue_quartile,
  count(ngb) as ngb_count,
  round(avg(r.total_revenue::numeric), 2) as avg_revenue,
  round(avg(s.athlete_stipends::numeric), 2) as avg_stipends,
  round(avg(s.athlete_stipends::numeric / nullif(membership_size, 0)), 2) as avg_stipend_per_athlete
from revenue_quartiles r
join gold.SportBenefitsStatementsDataByYear s 
on r.overall_parent_ngb = s.ngb
group by r.revenue_quartile
order by r.revenue_quartile;

-- Analyze funding patterns for NGBs grouped by NCAA-affiliated vs non-NCAA
with funding_per_ncaa_group as (
	select ncaa_sport,
		round( sum(Athlete_360
				+ Athlete_Stipends
				+ Coaching_Education
				+ COVID_Athlete_Assistance_Fund
				+ Elite_Athlete_Health_Insurance
				+ High_Performance_Grants
				+ High_Performance_Special_Grants
				+ National_Medical_Network
				+ NGB_HPMO_COVID_Grants
				+ Operation_Gold
				+ Paralympic_Sport_Development_Grants
				+ Restricted_Grants
				+ Sport_Science_Services
				+ Sports_Medicine_Clinics
				+ Facilities_Chula_Vista_California
				+ Facilities_Colorado_Springs_Colorado
				+ Facilities_Lake_Placid_New_York
				+ Facilities_Salt_Lake_City_Utah
			)::numeric,2) as funding_per_ncaa_group
	from gold.SportBenefitsStatementsDataByYear
	where year = 2020
	group by ncaa_sport 
)
select ncaa_sport,
	funding_per_ncaa_group,
	sum(funding_per_ncaa_group) over () as total_funding,
	round(100.0*funding_per_ncaa_group/sum(funding_per_ncaa_group) over (),2) as pct
from funding_per_ncaa_group;