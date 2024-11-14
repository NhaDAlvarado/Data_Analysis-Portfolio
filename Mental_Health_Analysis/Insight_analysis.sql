-- 1. What is the distribution of respondents by gender?
select gender, 
	round(100.0*count(*)/ (select count(*) from mental_health),2) as percentage
from mental_health
group by gender; 

-- 2. Which countries have the highest number of respondents?
select country, count(*) as num_of_respondents 
from mental_health
group by country
order by num_of_respondents desc;

-- 3. What percentage of respondents report having a family history of mental illness?
select family_history,
round(100.0*count(*)/ (select count(*) from mental_health),2) as percentage
from mental_health 
where family_history = 'Yes'
group by family_history;

-- 4. How many respondents have sought treatment for mental health issues?
select treatment, 
	round(100.0*count(*)/ (select count(*) from mental_health),2) as percentage
from mental_health
group by treatment;

-- 5. What is the average duration of days spent indoors by respondents?
select days_indoors, count(*) as num_of_respondents 
from mental_health 
group by days_indoors 
order by num_of_respondents desc; 

-- 6. Do self-employed individuals report a higher rate of mental health issues than employed individuals?
with have_mental_issue as (
	select self_employed, count(*) as num_of_mental_respondents
	from mental_health
	where self_employed is not null and mental_health_history = 'Yes'
	group by self_employed 
),
count_num_respondent_per_employed_type as (
	select self_employed, count(*) as num_of_respondents
	from mental_health
	where self_employed is not null 
	group by self_employed 
)
select e.self_employed, num_of_mental_respondents, num_of_respondents,
	round(100.0* num_of_mental_respondents/num_of_respondents,2) as percentage  
from have_mental_issue as m
join count_num_respondent_per_employed_type as e 
on m.self_employed = e.self_employed;

-- 7. How does the rate of mental health treatment vary by country?
with num_of_seeking_treatment_per_country as (
	select country, count(*) as num_of_respondent_w_treatment
	from mental_health
	where treatment = 'Yes'
	group by country 
),
num_of_respondents_per_country as (
	select country, count(*) as num_of_respondent
	from mental_health
	group by country 
)
select t.country, num_of_respondent_w_treatment , num_of_respondent,
round(100.0* num_of_respondent_w_treatment / num_of_respondent,2) as percentage 
from num_of_seeking_treatment_per_country as t
join num_of_respondents_per_country as r
on t.country = r.country 
order by percentage desc; 

-- 8. What is the correlation between family history and seeking treatment?
select family_history, treatment, count(*) as numof_respondent,
	round(
		100.0*count(*) / (sum(count(*)) over (partition by family_history))
	,2) as percentage 
from mental_health
group by family_history, treatment
order by family_history desc;

-- 9. Which occupation has the highest reported rate of mental health struggles?
with struggle_respondents_per_job as (
	select occupation, count(*) as num_respondents_has_struggles
	from mental_health 
	where coping_struggles = 'Yes'	
	group by occupation 
),
respondents_per_job as (
	select occupation, count(*) as num_respondents 
	from mental_health 	
	group by occupation 
)
select j.occupation, num_respondents_has_struggles , num_respondents,
round(100.0* num_respondents_has_struggles / num_respondents,2) as percentage 
from respondents_per_job as j
join struggle_respondents_per_job as s 
on j.occupation = s.occupation 
order by percentage desc;

-- 10.What proportion of respondents report growing stress levels?
select growing_stress, 
	round(100.0*count(*)/ (select count(*) from mental_health),2) as percentage
from mental_health
group by growing_stress;

-- 11.How many respondents report changes in habits due to stress?
select growing_stress, changes_habits, count(*) as num_of_respondents
from mental_health
where growing_stress = 'Yes'and changes_habits = 'Yes'	
group by growing_stress, changes_habits;

-- 12.Are there significant differences in mental health interview openness by gender?
select gender, mental_health_interview, count(*) as num_of_respondent,
	round(100.0*count(*) / sum(count(*)) over (partition by gender),2) as percentage  
from mental_health
group by gender, mental_health_interview
order by gender, percentage;  

-- 13.How does mood swing severity vary across occupation ?
select occupation, mood_swings, count(*) as num_of_respondents,
	round(100.0*count(*) / sum(count(*)) over (partition by occupation),2) as percentage 
from mental_health 
group by occupation, mood_swings 
order by occupation, percentage desc; 

-- 14.What percentage of respondents feel socially weak or isolated?
select social_weakness, 
	round(100.0*count(*)/(select count(*) from mental_health),2) as percentage
from mental_health 
group by social_weakness; 

-- 15.What are the most common occupations among respondents?
select occupation, count(*) as num_of_respondents
from mental_health
group by occupation
order by num_of_respondents desc; 

-- 16.Is there a difference in mental health issues reported by those who work indoors for prolonged periods?
-- select * from mental_health

-- 17.Do respondents with a family history of mental health issues report higher rates of coping struggles?
-- 18.What percentage of respondents feel their work interest has decreased?
-- 19.How does the availability of care options vary across countries?
-- 20.Which gender reports higher levels of coping struggles?
-- 21.How does treatment-seeking behavior vary between those with and without family histories?
-- 22.What are the top five countries in terms of mood swings reported by respondents?
-- 23.How do stress levels vary among different occupations?
-- 24.What is the relationship between habit changes and growing stress?
-- 25.Is there a difference in mental health interview openness by occupation?
-- 26.Which country has the highest reported percentage of social weakness among respondents?
-- 27.How does mood swing severity impact treatment-seeking behavior?
-- 28.What percentage of respondents are self-employed, and do they report higher stress levels?
-- 29.Which occupation reports the lowest coping struggles?
-- 30.Are there regional differences in the availability of mental health care options?
-- 31.How do mood swings correlate with the feeling of social weakness?
-- 32.How many respondents feel mentally strong despite a family history of mental health issues?
-- 33.What is the proportion of respondents by country who report decreased work interest?
-- 34.What is the relationship between mood swings and growing stress levels?
-- 35.Do respondents who report changes in habits also report increased stress?
-- 36.Which occupations report the highest levels of social weakness?
-- 37.How does care option availability correlate with respondents’ willingness for interviews?
-- 38.Are there differences in coping struggles based on days spent indoors?
-- 39.How does occupation impact mood swing levels?
-- 40.What is the percentage of respondents who feel mental health care options are available to them?
-- 41.What are the top factors contributing to growing stress among respondents?
-- 42.How do gender differences impact the likelihood of seeking mental health treatment?
-- 43.How many respondents report both family history and increased stress?
-- 44.Is there a relationship between work interest and mood swings?
-- 45.How does social weakness impact the willingness for mental health interviews?
-- 46.How do habit changes correlate with family history of mental health issues?
-- 47.Which country has the highest proportion of treatment-seeking respondents?
-- 48.How many respondents report no coping struggles, regardless of mood swings?
-- 49.How does work interest change across different age groups (if age data were available)?
-- 50.Are there differences in mood swings among self-employed vs. corporate workers?