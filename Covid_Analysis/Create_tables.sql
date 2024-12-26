-- Table for CovidVaccinations.csv
CREATE TABLE CovidVaccinations (
    iso_code VARCHAR(10),  
	continent VARCHAR(15),
    location VARCHAR(255),
    date DATE,
	new_tests BIGINT,  
    total_tests BIGINT,            
    total_tests_per_thousand  FLOAT,
    new_tests_per_thousand FLOAT,
	new_tests_smoothed BIGINT,
	new_tests_smoothed_per_thousand FLOAT,
    positive_rate FLOAT,
	tests_per_case FLOAT,
	tests_units TEXT,
    total_vaccinations BIGINT,
	people_vaccinated BIGINT,
	people_fully_vaccinated BIGINT,
	new_vaccinations BIGINT,
	new_vaccinations_smoothed BIGINT,
    total_vaccinations_per_hundred FLOAT,
    people_vaccinated_per_hundred FLOAT,
    people_fully_vaccinated_per_hundred FLOAT,
	new_vaccinations_smoothed_per_million FLOAT,
	stringency_index FLOAT,
	population_density FLOAT,
	median_age FLOAT,
	aged_65_older FLOAT,
	aged_70_older FLOAT,
	gdp_per_capita FLOAT,
	extreme_poverty FLOAT,
	cardiovasc_death_rate FLOAT,
	diabetes_prevalence FLOAT,
	female_smokers FLOAT,
	male_smokers FLOAT,
	handwashing_facilities FLOAT,
	hospital_beds_per_thousand FLOAT,
	life_expectancy FLOAT,
	human_development_index FLOAT
);

SELECT * FROM CovidVaccinations


-- Table for CovidDeaths.csv
CREATE TABLE CovidDeaths (
	iso_code VARCHAR(10),  
	continent VARCHAR(15),
    location VARCHAR(255),
    date DATE,
	total_cases BIGINT,
	new_cases BIGINT, 
	new_cases_smoothed FLOAT,
    total_deaths BIGINT,  
	new_deaths BIGINT,
	new_deaths_smoothed FLOAT,
    total_cases_per_million  FLOAT,
    new_cases_per_million FLOAT,
	new_cases_smoothed_per_million FLOAT,
	total_deaths_per_million FLOAT,
	new_deaths_per_million FLOAT,
	new_deaths_smoothed_per_million FLOAT,
	reproduction_rate FLOAT,
	icu_patients BIGINT,
	icu_patients_per_million FLOAT,
	hosp_patients BIGINT,
	hosp_patients_per_million FLOAT,
	weekly_icu_admissions FLOAT,
	weekly_icu_admissions_per_million FLOAT,
	weekly_hosp_admissions FLOAT,
	weekly_hosp_admissions_per_million FLOAT,
	new_tests BIGINT,
	total_tests BIGINT,
	total_tests_per_thousand FLOAT,
	new_tests_per_thousand FLOAT,
	new_tests_smoothed FLOAT,
	new_tests_smoothed_per_thousand FLOAT,
	positive_rate FLOAT, --
	tests_per_case FLOAT,--
	tests_units TEXT, --
    total_vaccinations BIGINT, --
	people_vaccinated BIGINT, --
	people_fully_vaccinated BIGINT, --
	new_vaccinations BIGINT, --
	new_vaccinations_smoothed BIGINT, --
    total_vaccinations_per_hundred FLOAT, --
    people_vaccinated_per_hundred FLOAT, --
    people_fully_vaccinated_per_hundred FLOAT, --
	new_vaccinations_smoothed_per_million FLOAT, --
	stringency_index FLOAT, --
	population BIGINT, 
	population_density FLOAT, --
	median_age FLOAT, --
	aged_65_older FLOAT, --
	aged_70_older FLOAT, --
	gdp_per_capita FLOAT, --
	extreme_poverty FLOAT, --
	cardiovasc_death_rate FLOAT, --
	diabetes_prevalence FLOAT, --
	female_smokers FLOAT, --
	male_smokers FLOAT, --
	handwashing_facilities FLOAT, --
	hospital_beds_per_thousand FLOAT, --
	life_expectancy FLOAT, --
	human_development_index FLOAT --
);

select * from coviddeaths

