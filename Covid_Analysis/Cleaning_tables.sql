UPDATE CovidVaccinations
SET
    new_tests = COALESCE(new_tests, 0),
    total_tests = COALESCE(total_tests, 0),
    total_tests_per_thousand = COALESCE(total_tests_per_thousand, 0.0),
    new_tests_per_thousand = COALESCE(new_tests_per_thousand, 0.0),
    new_tests_smoothed = COALESCE(new_tests_smoothed, 0),
    new_tests_smoothed_per_thousand = COALESCE(new_tests_smoothed_per_thousand, 0.0),
    positive_rate = COALESCE(positive_rate, 0.0),
    tests_per_case = COALESCE(tests_per_case, 0.0),
    tests_units = COALESCE(tests_units, 'unknown'),
    total_vaccinations = COALESCE(total_vaccinations, 0),
    people_vaccinated = COALESCE(people_vaccinated, 0),
    people_fully_vaccinated = COALESCE(people_fully_vaccinated, 0),
    new_vaccinations = COALESCE(new_vaccinations, 0),
    new_vaccinations_smoothed = COALESCE(new_vaccinations_smoothed, 0),
    total_vaccinations_per_hundred = COALESCE(total_vaccinations_per_hundred, 0.0),
    people_vaccinated_per_hundred = COALESCE(people_vaccinated_per_hundred, 0.0),
    people_fully_vaccinated_per_hundred = COALESCE(people_fully_vaccinated_per_hundred, 0.0),
    new_vaccinations_smoothed_per_million = COALESCE(new_vaccinations_smoothed_per_million, 0.0),
    stringency_index = COALESCE(stringency_index, 0.0),
    population_density = COALESCE(population_density, 0.0),
    median_age = COALESCE(median_age, 0.0),
    aged_65_older = COALESCE(aged_65_older, 0.0),
    aged_70_older = COALESCE(aged_70_older, 0.0),
    gdp_per_capita = COALESCE(gdp_per_capita, 0.0),
    extreme_poverty = COALESCE(extreme_poverty, 0.0),
    cardiovasc_death_rate = COALESCE(cardiovasc_death_rate, 0.0),
    diabetes_prevalence = COALESCE(diabetes_prevalence, 0.0),
    female_smokers = COALESCE(female_smokers, 0.0),
    male_smokers = COALESCE(male_smokers, 0.0),
    handwashing_facilities = COALESCE(handwashing_facilities, 0.0),
    hospital_beds_per_thousand = COALESCE(hospital_beds_per_thousand, 0.0),
    life_expectancy = COALESCE(life_expectancy, 0.0),
    human_development_index = COALESCE(human_development_index, 0.0);

select * from covidvaccinations 

UPDATE CovidDeaths
SET
    total_cases = COALESCE(total_cases, 0),
    new_cases = COALESCE(new_cases, 0),
    new_cases_smoothed = COALESCE(new_cases_smoothed, 0.0),
    total_deaths = COALESCE(total_deaths, 0),
    new_deaths = COALESCE(new_deaths, 0),
    new_deaths_smoothed = COALESCE(new_deaths_smoothed, 0.0),
    total_cases_per_million = COALESCE(total_cases_per_million, 0.0),
    new_cases_per_million = COALESCE(new_cases_per_million, 0.0),
    new_cases_smoothed_per_million = COALESCE(new_cases_smoothed_per_million, 0.0),
    total_deaths_per_million = COALESCE(total_deaths_per_million, 0.0),
    new_deaths_per_million = COALESCE(new_deaths_per_million, 0.0),
    new_deaths_smoothed_per_million = COALESCE(new_deaths_smoothed_per_million, 0.0),
    reproduction_rate = COALESCE(reproduction_rate, 0.0),
    icu_patients = COALESCE(icu_patients, 0),
    icu_patients_per_million = COALESCE(icu_patients_per_million, 0.0),
    hosp_patients = COALESCE(hosp_patients, 0),
    hosp_patients_per_million = COALESCE(hosp_patients_per_million, 0.0),
    weekly_icu_admissions = COALESCE(weekly_icu_admissions, 0.0),
    weekly_icu_admissions_per_million = COALESCE(weekly_icu_admissions_per_million, 0.0),
    weekly_hosp_admissions = COALESCE(weekly_hosp_admissions, 0.0),
    weekly_hosp_admissions_per_million = COALESCE(weekly_hosp_admissions_per_million, 0.0),
    new_tests = COALESCE(new_tests, 0),
    total_tests = COALESCE(total_tests, 0),
    total_tests_per_thousand = COALESCE(total_tests_per_thousand, 0.0),
    new_tests_per_thousand = COALESCE(new_tests_per_thousand, 0.0),
    new_tests_smoothed = COALESCE(new_tests_smoothed, 0),
    new_tests_smoothed_per_thousand = COALESCE(new_tests_smoothed_per_thousand, 0.0),
    positive_rate = COALESCE(positive_rate, 0.0),
    tests_per_case = COALESCE(tests_per_case, 0.0),
    tests_units = COALESCE(tests_units, 'unknown'),
    total_vaccinations = COALESCE(total_vaccinations, 0),
    people_vaccinated = COALESCE(people_vaccinated, 0),
    people_fully_vaccinated = COALESCE(people_fully_vaccinated, 0),
    new_vaccinations = COALESCE(new_vaccinations, 0),
    new_vaccinations_smoothed = COALESCE(new_vaccinations_smoothed, 0),
    total_vaccinations_per_hundred = COALESCE(total_vaccinations_per_hundred, 0.0),
    people_vaccinated_per_hundred = COALESCE(people_vaccinated_per_hundred, 0.0),
    people_fully_vaccinated_per_hundred = COALESCE(people_fully_vaccinated_per_hundred, 0.0),
    new_vaccinations_smoothed_per_million = COALESCE(new_vaccinations_smoothed_per_million, 0.0),
    stringency_index = COALESCE(stringency_index, 0.0),
    population = COALESCE(population, 0),
    population_density = COALESCE(population_density, 0.0),
    median_age = COALESCE(median_age, 0.0),
    aged_65_older = COALESCE(aged_65_older, 0.0),
    aged_70_older = COALESCE(aged_70_older, 0.0),
    gdp_per_capita = COALESCE(gdp_per_capita, 0.0),
    extreme_poverty = COALESCE(extreme_poverty, 0.0),
    cardiovasc_death_rate = COALESCE(cardiovasc_death_rate, 0.0),
    diabetes_prevalence = COALESCE(diabetes_prevalence, 0.0),
    female_smokers = COALESCE(female_smokers, 0.0),
    male_smokers = COALESCE(male_smokers, 0.0),
    handwashing_facilities = COALESCE(handwashing_facilities, 0.0),
    hospital_beds_per_thousand = COALESCE(hospital_beds_per_thousand, 0.0),
    life_expectancy = COALESCE(life_expectancy, 0.0),
    human_development_index = COALESCE(human_development_index, 0.0);

select * from coviddeaths