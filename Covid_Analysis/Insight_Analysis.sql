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
-- select * from covidvaccinations 
-- select * from coviddeaths

-- 12.How do vaccination rates correlate with new cases and deaths?
-- 13.What is the vaccination trend for the top 10 most affected countries by deaths?
-- 14.Which countries have the highest daily vaccination rates per million population?
-- 15.How does vaccination rate per hundred correlate with the reproduction rate?
-- 16.Which countries achieved the fastest increase in vaccinations over time?
-- 17.How do vaccination trends differ by continent?
-- 18.What is the relationship between vaccination rates and ICU admissions?
-- 19.How does the number of fully vaccinated individuals impact the stringency index?
-- 20.Which countries have the highest testing rates per thousand population?
-- 21.What is the average positive rate globally, and how does it vary by continent?
-- 22.How does the number of tests correlate with the total number of cases?
-- 23.Which countries report the lowest positive test rates consistently?
-- 24.How does positive test rate change over time in countries with high vaccination coverage?
-- 25.What is the trend of daily new tests versus daily new cases globally?
-- 26.Which countries currently have the highest ICU and hospital admissions?
-- 27.How do ICU admissions correlate with new deaths in each country?
-- 28.What is the global trend in weekly ICU and hospital admissions?
-- 29.Which countries report the highest ICU patients per million population?
-- 30.How does the number of hospital beds per thousand correlate with the reproduction rate?
-- 31.How does population density correlate with the number of total cases and deaths?
-- 32.What is the relationship between median age and total deaths per million population?
-- 33.How do smoking rates (male and female) correlate with death rates globally?
-- 34.Which countries with low GDP per capita experienced the highest death rates?
-- 35.How does life expectancy correlate with COVID-19 case and death rates?
-- 36.Which countries have the highest extreme poverty levels and how does that relate to vaccination rates?
-- 37.What are the total cases, deaths, and vaccinations by continent over time?
-- 38.Which countries show a significant reduction in new cases after vaccination rollout?
-- 39.What are the top 5 countries in Asia, Europe, and Africa by total cases?
-- 40.How do trends of new cases and deaths compare across continents?
-- 41.How have vaccination efforts impacted stringency indexes in the past 12 months?
-- 42.What is the trend of hospital admissions in low-income vs. high-income countries?
-- 43.Which countries have high vaccination rates but still report increasing new cases?
-- 44.What is the correlation between handwashing facilities availability and COVID-19 death rates?
-- 45.How do reproduction rates differ between countries with high vaccination coverage and those with low coverage?
-- 46.What is the impact of GDP per capita on ICU admissions per million population?
-- 47.Which countries with a high population density managed to control reproduction rates effectively?
-- 48.How does the number of tests per case vary across countries and regions?
-- 49.How have extreme poverty and stringency index together impacted vaccination rates?
-- 50.What combination of factors (e.g., GDP, healthcare access, age demographics) is most strongly associated with low COVID-19 death rates?