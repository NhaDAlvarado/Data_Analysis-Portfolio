-- 1.What is the total number of COVID-19 cases and deaths for each country?
select location, sum(new_cases) as num_of_cases, sum(new_deaths) as num_of_deaths
from coviddeaths
group by location
order by location; 

-- 2.Which country has the highest case fatality rate (deaths/cases)?
select location, coalesce(round(sum(new_deaths)/nullif(sum(new_cases),0),2),0) as fatality_rate
from coviddeaths
group by location
order by fatality_rate desc
limit 1;

-- 3.What is the trend of new cases and new deaths over time globally?
select to_char(date, 'MM-YYYY') as month_year,
	sum(new_cases) as num_of_cases, 
	sum(new_deaths) as num_of_deaths
from coviddeaths 
group by month_year 
order by month_year; 

-- 4.Which countries have the fastest-growing number of cases in the last 30 days?
select location, sum(new_cases) as growing_cases
from coviddeaths
where date between (date'2021-04-30' - interval '30 days') and date'2021-04-30'
group by location 
order by growing_cases desc; 

-- 5.How do new cases smoothed values compare to raw new cases over time globally?
select date,
    sum(new_cases) as total_raw_new_cases,
    sum(new_cases_smoothed) as total_smoothed_new_cases,
    round(sum(new_cases_smoothed)::numeric / nullif(sum(new_cases)::numeric, 0), 2) as smoothed_to_raw_ratio
from coviddeaths
group by date
order by date;

-- 6.What is the correlation between total cases and total deaths across all countries?
select corr(total_new_cases, total_new_deaths) as correlation
from ( 
	select location,
	sum(new_cases) as total_new_cases,
	sum(new_deaths) as total_new_deaths
	from coviddeaths
	group by location
	) as q; 
/*The result is nearly 1; that meant the more new cases, the more deaths. */

-- 7.Which countries have maintained low death rates despite high case counts?
select location, 
	sum(new_cases) as num_of_cases, 
	sum(new_deaths) as num_of_deaths,
	round(100.0* sum(new_deaths)/nullif(sum(new_cases),0)) as percentage 
from coviddeaths
group by location
order by percentage; 

-- 8.How does the total number of deaths compare per million population across continents?
select continent, round(sum(new_deaths_per_million)::numeric,2) as total_death_per_mil 
from coviddeaths
group by continent;

-- 9.What percentage of each country’s population has been infected with COVID-19?
select location, sum(new_cases) as num_of_cases, population,
	round(100.0*sum(new_cases)/nullif(population,0),5) as percentage 
from coviddeaths
group by location, population 
order by percentage desc ; 

-- 10.What percentage of the global population has been fully vaccinated?
with fully_vaccinated as (
	select location, date, people_fully_vaccinated, population,
		row_number() over (partition by location order by date desc) as rn
	from coviddeaths
)
, fully_vaccinated_per_location as (
	select location, people_fully_vaccinated, population 
	from fully_vaccinated
	where rn = 1 and location = 'World'
)
select location, people_fully_vaccinated, population,
	round(100.0*people_fully_vaccinated/population,2) as percentage
from fully_vaccinated_per_location;

-- 11.Which countries have vaccinated more than 70% of their population?
with fully_vaccinated as (
	select location, date, people_fully_vaccinated, population,
		row_number() over (partition by location order by date desc) as rn
	from coviddeaths
)
, fully_vaccinated_per_location as (
	select location, people_fully_vaccinated, population 
	from fully_vaccinated
	where rn = 1 
)
select location, people_fully_vaccinated, population,
	round(100.0*people_fully_vaccinated/nullif(population,0),2) as percentage
from fully_vaccinated_per_location
where round(100.0*people_fully_vaccinated/nullif(population,0),2) >= 70;

-- 12.How do vaccination rates correlate with new cases and deaths?
select 
    corr(people_fully_vaccinated, new_cases) as correlation_vaccination_cases,
    corr(people_fully_vaccinated, new_deaths) as correlation_vaccination_deaths
from coviddeaths
where people_fully_vaccinated is not null
    and new_cases is not null
    and new_deaths is not null;

-- 13.What is the vaccination trend for the top 10 most affected countries by deaths?
with latest_info as (
	select location, total_deaths, population, people_fully_vaccinated,
		row_number() over (partition by location order by date desc) as rn
	from coviddeaths
),
top_10_countries as (
	select location
	from latest_info
	where rn =1 
	order by round(100.0*total_deaths/nullif(population,0),2) desc 
	limit 10
)
select d.location, d.date,
	round(100.0*people_fully_vaccinated/ nullif(population,0),2) as vaccinated_percentage
from coviddeaths as d
inner join top_10_countries as c
on d.location = c.location
order by d.location, d.date; 
	
-- 14.Which countries have the highest daily vaccination rates per million population?
select location, date, people_fully_vaccinated_per_hundred
from coviddeaths
order by people_fully_vaccinated_per_hundred desc;

-- 15.How does vaccination rate per hundred correlate with the reproduction rate?
select corr(people_fully_vaccinated_per_hundred, reproduction_rate) as corr
from coviddeaths
where people_fully_vaccinated_per_hundred is not null
	and reproduction_rate is not null;

-- 16.Which countries achieved the fastest increase in vaccinations over time?
with vaccination_trend as (
	select location, date, people_vaccinated_per_hundred,
			lead(people_vaccinated_per_hundred) 
				over (partition by location order by date) as next_day_ppl_vaccinated_per_100
	from coviddeaths
),
daily_trend as (
	select location,
			(next_day_ppl_vaccinated_per_100 - people_vaccinated_per_hundred) as daily_increase_trend 
	from vaccination_trend
)
select location, round(avg(daily_increase_trend)::numeric,2) as avg_daily_trend
from daily_trend
group by location
order by avg_daily_trend desc 
limit 10; 

-- 17.How do vaccination trends differ by continent?
with vaccination_trend as (
	select continent, date, people_vaccinated_per_hundred,
			lead(people_vaccinated_per_hundred) 
				over (partition by location order by date) as next_day_ppl_vaccinated_per_100
	from coviddeaths
),
daily_trend as (
	select continent,
			(next_day_ppl_vaccinated_per_100 - people_vaccinated_per_hundred) as daily_increase_trend 
	from vaccination_trend
)
select continent, round(avg(daily_increase_trend)::numeric,2) as avg_daily_increase_trend
from daily_trend
group by continent
order by avg_daily_increase_trend desc; 

-- 18.What is the relationship between vaccination rates and ICU admissions?
select 
    corr(people_vaccinated_per_hundred, icu_patients_per_million) as correlation_vaccination_icu
from coviddeaths
where people_vaccinated_per_hundred is not null
    and icu_patients_per_million is not null;

-- 19.How does the number of fully vaccinated individuals impact the stringency index?
select location, corr(people_fully_vaccinated,stringency_index) as corr 
from coviddeaths 
group by location;

-- 20.Which countries have the highest testing rates per thousand population?
with testing_per_thousand as (
	select location, total_tests_per_thousand,
		row_number() over (partition by location order by date desc) as rn
	from covidvaccinations 
)
select location, total_tests_per_thousand
from testing_per_thousand
where rn =1
order by total_tests_per_thousand desc; 

-- 21.What is the average positive rate globally, and how does it vary by continent?
select location, round(avg(positive_rate)::numeric,2) as avg_positive_rate
from coviddeaths 
group by location 
order by avg_positive_rate desc; 

-- 22.How does the number of tests correlate with the total number of cases?
select corr(total_cases, total_tests) as corr
from coviddeaths; 

-- 23.Which countries report the lowest positive test rates consistently?
select location, avg(positive_rate) as avg_rate
from coviddeaths
where positive_rate != 0
group by location
order by avg_rate; 

-- 24.How does positive test rate change over time in countries with high vaccination coverage?
with latest_info as (
	select location, positive_rate, population, people_fully_vaccinated,
		row_number() over (partition by location order by date desc) as rn
	from coviddeaths
)
,top_10_countries as (
	select location
	from latest_info
	where rn =1 
	order by round(100.0*people_fully_vaccinated/nullif(population,0),2) desc 
	limit 10
)
select d.location, d.date, positive_rate
from coviddeaths as d
inner join top_10_countries as c
on d.location = c.location
order by d.location, d.date; 

-- 25.What is the trend of daily new tests versus daily new cases globally?
select date, sum(new_cases) as daily_new_cases, sum(new_tests) as daily_new_tests
from coviddeaths
group by date 
order by date; 

-- 26.Which countries currently have the highest ICU and hospital admissions?
select location, 
	sum(weekly_hosp_admissions) as hosp_admission, 
	sum(weekly_icu_admissions) as icu_admission
from coviddeaths
where weekly_hosp_admissions != 0
	and weekly_icu_admissions != 0
group by location; 

-- 27.How do ICU admissions correlate with new deaths in each country?
select location,
	corr(new_deaths, weekly_icu_admissions) as corr
from coviddeaths
where weekly_icu_admissions != 0
	and new_deaths != 0 
group by location
order by location;

-- 28.What is the global trend in weekly ICU and hospital admissions?
select date, 
	sum(weekly_hosp_admissions) as hosp_admission, 
	sum(weekly_icu_admissions) as icu_admission
from coviddeaths
where weekly_hosp_admissions != 0
	and weekly_icu_admissions != 0
group by date;

-- 29.Which countries report the highest ICU patients per million population?
select location, sum(icu_patients_per_million) as icu_per_mil
from coviddeaths
group by location
order by icu_per_mil desc; 

-- 30.How does the number of hospital beds per thousand correlate with the reproduction rate?
select corr(hospital_beds_per_thousand,reproduction_rate) as corr
from coviddeaths 
where hospital_beds_per_thousand != 0
	and reproduction_rate != 0;

-- 31.How does population density correlate with the number of total cases and deaths?
select location, 
	corr(total_cases, population_density) as corr_cases_density,
	corr(total_deaths, population_density) as corr_deaths_density
from coviddeaths 
group by location; 

-- 32.What is the relationship between median age and total deaths per million population?
select corr(median_age, total_deaths_per_million) as corr
from coviddeaths; 

-- 33.How do smoking rates (male and female) correlate with death rates globally?
select location, 
	corr(female_smokers, total_deaths) as fm_smokers_w_total_deaths,
	corr(male_smokers, total_deaths) as m_smokers_w_total_deaths
from coviddeaths
group by location;

-- 34.Which countries with low GDP per capita experienced the highest death rates?
with latest_info as (
	select location, gdp_per_capita, total_deaths, total_cases,
		row_number() over (partition by location order by date desc) as rn
	from coviddeaths 
)
select location, gdp_per_capita, total_deaths, total_cases,
	round(100.0*total_deaths/nullif(total_cases,0),5) as deaths_rate 
from latest_info
where rn =1 and gdp_per_capita != 0
order by gdp_per_capita asc, deaths_rate desc; 

-- 35.How does life expectancy correlate with COVID-19 case and death rates?
select corr(life_expectancy, total_deaths/nullif(total_cases,0)) as corr_life_cases_deaths
	-- ,corr(life_expectancy, total_deaths) as corr_deaths_cases
from coviddeaths; 

-- 36.Which countries have the highest extreme poverty levels and how does that relate to vaccination rates?
with poverty_data as (
    select location,
        avg(extreme_poverty) as avg_extreme_poverty,
        avg (people_vaccinated_per_hundred) as avg_vaccination_rate
    from coviddeaths
    where extreme_poverty !=0
        and people_vaccinated_per_hundred !=0
    group by location
),
correlation_data as (
    select corr(extreme_poverty, people_vaccinated_per_hundred) as poverty_vaccination_correlation
    from coviddeaths
    where extreme_poverty != 0
        and people_vaccinated_per_hundred != 0
)
select  p.location,
    p.avg_extreme_poverty,
    p.avg_vaccination_rate,
    c.poverty_vaccination_correlation
from poverty_data p
cross join correlation_data c
order by avg_extreme_poverty desc
limit 10;

-- 37.What are the total cases, deaths, and vaccinations by continent over time?
select continent, 
	sum(new_cases) as total_cases, 
	sum(new_deaths) as total_deaths,
	sum(new_vaccinations) as total_vaccinations
from coviddeaths
group by continent; 

-- 38.Which countries show a significant reduction in new cases after vaccination rollout?
with vaccination_rollout as (
    select location, date,
        people_vaccinated_per_hundred,
        avg(new_cases) over (partition by location order by date rows between unbounded preceding and current row) as avg_new_cases_before_vaccination
    from coviddeaths
    where people_vaccinated_per_hundred != 0 
),
post_vaccination_data as (
    select location,
        avg(new_cases) as avg_new_cases_after_vaccination
    from coviddeaths
    where 
        people_vaccinated_per_hundred >= 10 -- Threshold for vaccination rollout
        and new_cases != 0 
    group by location
),
case_reduction as (
    select v.location,
        min(v.date) as rollout_start_date,
        p.avg_new_cases_after_vaccination,
        min(v.avg_new_cases_before_vaccination) as avg_new_cases_before_vaccination,
        (min(v.avg_new_cases_before_vaccination) - p.avg_new_cases_after_vaccination) /
        nullif(min(v.avg_new_cases_before_vaccination), 0) * 100 as reduction_percentage
    from vaccination_rollout v
    join post_vaccination_data p
    on v.location = p.location
    group by v.location, p.avg_new_cases_after_vaccination
)
select 
    location,
    rollout_start_date,
    avg_new_cases_before_vaccination,
    avg_new_cases_after_vaccination,
    round(reduction_percentage, 2) as reduction_percentage
from case_reduction
where 
    reduction_percentage > 0 -- Filters only countries with significant reductions
order by reduction_percentage desc
limit 10;

-- 39.What are the top 5 countries in Asia, Europe, and Africa by total cases?
with ranking_top_5 as (
	select continent, location, sum(new_cases) as total_cases,
		dense_rank() over (partition by continent order by sum(new_cases) desc) as ranking
	from coviddeaths
	group by continent, location 
)
select continent, location, total_cases
from ranking_top_5
where ranking <= 5 
	and continent in ('Asia', 'Europe', 'Africa');

-- 40.How do trends of new cases and deaths compare across continents?
select continent, extract(month from date) as month , extract(year from date) as year,  
sum(new_cases) as total_cases_in_continent,
sum(new_deaths) as total_deaths_in_continent
from coviddeaths
group by continent,year, month 
order by continent, year, month; 

-- 41.How have vaccination efforts impacted stringency indexes in the past 12 months?
select extract(month from date) as month , 
	extract(year from date) as year, 
	sum(people_fully_vaccinated) as total_fully_vaccinated,
	round(avg(stringency_index)::numeric,2) as avg_retriction
from coviddeaths 
where 
    date between (date '2021-04-01' - interval '12 months') and date '2021-04-30'
group by month, year
order by year, month; 

-- 42.What is the trend of hospital admissions in low-income vs. high-income countries?
with income_level as (
	select location, weekly_hosp_admissions,  
	    case 
	        when gdp_per_capita < 1046 then 'Low income'
	        when gdp_per_capita between 1046 and 4095 then 'Lower middle income'
	        when gdp_per_capita between 4096 and 12695 then 'Upper middle income'
	        else 'High income'
	    end as  income_level
	from coviddeaths
)
select location, income_level, sum(weekly_hosp_admissions) as total_admissions
from income_level
where income_level in ('Low income', 'High income')
group by location, income_level 
order by income_level;

-- 43.Which countries have high vaccination rates but still report increasing new cases?
with recent_trends as (
    select location, date,
        people_vaccinated_per_hundred,
        new_cases,
        lag(new_cases, 1) over (partition by location order by date) as previous_new_cases
    from coviddeaths
    where
        people_vaccinated_per_hundred >= 10 
        and new_cases != 0
),
increasing_cases as (
    select location,
        avg(people_vaccinated_per_hundred) as avg_vaccination_rate,
        avg(new_cases) as avg_new_cases,
        avg(new_cases - previous_new_cases) as avg_case_increase
    from recent_trends
    where new_cases > previous_new_cases 
    group by location
)
select location,
    round(avg_vaccination_rate::numeric, 2) as avg_vaccination_rate,
    round(avg_new_cases::numeric, 2) as avg_new_cases,
    round(avg_case_increase::numeric, 2) as avg_case_increase
from increasing_cases
order by avg_case_increase desc
limit 10;

-- 44.What is the correlation between handwashing facilities availability and COVID-19 death rates?
select corr(new_deaths_per_million, handwashing_facilities) as corr
from coviddeaths;  

-- 45.How do reproduction rates differ between countries with high vaccination coverage and those with low coverage?
with vaccination_rate as (
	select location, max(total_vaccinations) as total_vaccination, reproduction_rate,
		100.0*max(total_vaccinations)/nullif(population,0) as vaccination_rate
	from coviddeaths 
	group by location, population, reproduction_rate   
),
coverage as (
	select reproduction_rate,
		case when vaccination_rate > 25 then 'high coverage'
			else 'low coverage'
		end as coverage 
	from vaccination_rate 
)
select coverage, avg(reproduction_rate) as avg_reproduction_rate
from coverage
group by coverage; 

-- 46.What is the impact of GDP per capita on ICU admissions per million population?
select case 
	        when gdp_per_capita < 1046 then 'Low income'
	        when gdp_per_capita between 1046 and 4095 then 'Lower middle income'
	        when gdp_per_capita between 4096 and 12695 then 'Upper middle income'
	        else 'High income'
	    end as  income_level,
	avg(weekly_icu_admissions_per_million) as avg_icu_admission
from coviddeaths
where 
    gdp_per_capita != 0
    AND weekly_icu_admissions_per_million != 0
group by income_level; 

-- 47.Which countries with a high population density managed to control reproduction rates effectively?
with density_level as (
	select location, 
		case when population_density > 1000 then 'High'
			when population_density between 100 and 999 then 'Moderate'
			else 'Low'
		end as population_density_level, 
		avg(reproduction_rate) as avg_reproduction_rate  
	from coviddeaths 
	group by location, population_density_level 
)
select location, population_density_level, avg_reproduction_rate
from density_level
where population_density_level = 'High' and avg_reproduction_rate <1; 

-- 48.How does the number of tests per case vary across countries and regions?
select continent, location, 
	avg(tests_per_case) as avg_test_per_case 
from coviddeaths 
group by continent, location
order by continent; 

-- 49.How have extreme poverty and stringency index together impacted vaccination rates?
with poverty_stringency as (
	select location, 
		avg(extreme_poverty) as avg_extreme_poverty,
		avg(stringency_index) as avg_stringency_index, 
		avg(people_vaccinated_per_hundred) as avg_vaccination_rate
	from coviddeaths 
	where
        extreme_poverty != 0
        and stringency_index != 0
        and people_vaccinated_per_hundred != 0
	group by location
),
correlation_analysis as (
	select 
		corr (avg_extreme_poverty, avg_vaccination_rate) as correlation_poverty_vaccination,
        corr (avg_stringency_index, avg_vaccination_rate) as correlation_stringency_vaccination
	from poverty_stringency
)
select  
    p.location,
    p.avg_extreme_poverty,
    p.avg_stringency_index,
    p.avg_vaccination_rate,
    c.correlation_poverty_vaccination,
    c.correlation_stringency_vaccination
from poverty_stringency p
cross join correlation_analysis c
order by avg_extreme_poverty desc;

-- 50.What combination of factors (e.g., GDP, healthcare access, age demographics) 
-- is most strongly associated with low COVID-19 death rates?
with correlations as (
    select 
	corr(gdp_per_capita, total_deaths_per_million) as correlation_gdp_deaths,
	corr(hospital_beds_per_thousand, total_deaths_per_million) as correlation_hospital_beds_deaths,
	corr(life_expectancy, total_deaths_per_million) as correlation_life_expectancy_deaths,
	corr(median_age, total_deaths_per_million) as correlation_median_age_deaths,
	corr(aged_65_older, total_deaths_per_million) as correlation_aged_65_deaths,
	corr(extreme_poverty, total_deaths_per_million) as correlation_poverty_deaths,
	corr(population_density, total_deaths_per_million) as correlation_density_deaths,
	corr(stringency_index, total_deaths_per_million) as correlation_stringency_deaths
    from 
        coviddeaths
    where 
        total_deaths_per_million != 0
)
select * from  correlations;
