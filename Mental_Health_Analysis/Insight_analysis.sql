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
select days_indoors, mental_health_history, count(*) as num_of_respondent,
	round(100.0*count(*)/ (sum(count(*)) over (partition by days_indoors)),2) as percentage 
from mental_health
group by days_indoors, mental_health_history
order by days_indoors, percentage desc; 

-- 17.Do respondents with a family history of mental health issues report higher rates of coping struggles?
select family_history, coping_struggles, count(*) as num_of_respondent,
	round(100.0*count(*)/ (sum(count(*)) over (partition by family_history)),2) as percentage
from mental_health
where family_history = 'Yes'
group by family_history, coping_struggles;

-- 18.What percentage of respondents feel their work interest has decreased?
select work_interest, count(*) as num_of_respondent,
	round(100.0*count(*)/(select count(*) from mental_health),2) as percentage 
from mental_health
group by work_interest;

-- 19.How does the availability of care options vary across countries?
select country, count(*) as num_of_respondents
from mental_health
where care_options = 'Yes'
group by care_options, country
order by num_of_respondents desc; 

-- 20.Which gender reports higher levels of coping struggles?
select gender, coping_struggles, 
	round(100.0*count(*)/ (sum(count(*)) over (partition by gender)),2) as num_of_respondents
from mental_health
group by gender, coping_struggles;

-- 21.How does treatment-seeking behavior vary between those with and without family histories?
with seeking_treatment as (
	select family_history, count(*) as num_of_ppl_with_treatments
	from mental_health
	where treatment = 'Yes'
	group by family_history
),
num_of_ppl as (
	select family_history, count(*) as num_of_ppl
	from mental_health
	group by family_history
)
select t.family_history, num_of_ppl_with_treatments, num_of_ppl,
	round(100.0*num_of_ppl_with_treatments/num_of_ppl,2) as percentage 
from seeking_treatment as t
join num_of_ppl as n
on t.family_history = n.family_history;
	
-- 22.What are the top five countries in terms of mood swings reported by respondents?
select country, count(*) as num_of_respondents
from mental_health
where mood_swings = 'High'
group by country 
order by num_of_respondents desc; 

-- 23.How do stress levels vary among different occupations?
select occupation, growing_stress, 
	round(100.0*count(*)/sum(count(*)) over (partition by occupation),2) as percentage
from mental_health
group by occupation, growing_stress 
order by occupation, percentage desc; 

-- 24.What is the relationship between habit changes and growing stress?
select changes_habits, growing_stress, 
	round(100.0*count(*)/sum(count(*)) over (partition by changes_habits),2) as percentage
from mental_health
group by changes_habits, growing_stress 
order by changes_habits, percentage desc; 

-- 25.Is there a difference in mental health interview openness by occupation?
select occupation, mental_health_interview, 
	round(100.0*count(*)/sum(count(*)) over (partition by occupation),2) as percentage
from mental_health
group by occupation, mental_health_interview 
order by occupation, percentage desc; 

-- 26.Which country has the highest reported percentage of social weakness among respondents?
with respondents_by_country as (
	select country, count(*) as num_of_respondents
	from mental_health
	group by country
),
respondents_with_social_weakness as (
	select country, count(*) as social_weakness_respondents
	from mental_health
	where social_weakness = 'Yes'
	group by country
)
select s.country, social_weakness_respondents, num_of_respondents,
	round(100.0* social_weakness_respondents/ num_of_respondents,2) as percentage
from respondents_with_social_weakness as s
join respondents_by_country as r
on s.country = r.country 
order by percentage desc; 

-- 27.How does mood swing severity impact treatment-seeking behavior?
select treatment, mood_swings, 
	round(100.0*count(*)/sum(count(*)) over (partition by treatment),2) as percentage
from mental_health
group by treatment, mood_swings;

-- 28.What percentage of respondents are self-employed, and do they report higher stress levels?
select self_employed, growing_stress, 
	round(100.0*count(*)/sum(count(*)) over (partition by self_employed),2) as percentage 
from mental_health
where self_employed = 'Yes'
group by self_employed, growing_stress;

-- 29.Which occupation reports the lowest coping struggles?
with respondents_by_occupation as (
	select occupation, count(*) as num_of_respondents
	from mental_health
	group by occupation
),
respondents_with_copings_struggles as (
	select occupation, count(*) as copings_struggles_respondents
	from mental_health
	where coping_struggles = 'Yes'
	group by occupation
)
select s.occupation, copings_struggles_respondents, num_of_respondents,
	round(100.0* copings_struggles_respondents/ num_of_respondents,2) as percentage
from respondents_with_copings_struggles as s
join respondents_by_occupation as r
on s.occupation = r.occupation 
order by percentage;

-- 30.Are there regional differences in the availability of mental health care options?
select country, care_options, 
	round(100.0*count(*)/sum(count(*)) over (partition by country),2) as percentage
from mental_health
group by country, care_options;

-- 31.How do mood swings correlate with the feeling of social weakness?
select mood_swings, social_weakness, 
	round(100.0*count(*)/sum(count(*)) over (partition by mood_swings),2) as percentage
from mental_health
group by mood_swings, social_weakness; 

-- 32.How many respondents feel mentally strong despite a family history of mental health issues?
select family_history, mental_health_history,  count(*) as num_of_respondents 
from mental_health
where family_history = 'Yes' and mental_health_history = 'No'
group by family_history, mental_health_history;

-- 33.What is the proportion of respondents by country who report decreased work interest?
with num_of_ppl_no_work_interest as (
	select country, count(*) as num_of_ppl_wo_work_interest
	from mental_health
	where work_interest = 'No'
	group by country 
),
num_of_respondents_per_country as (
	select country, count(*) as num_of_respondent
	from mental_health
	group by country 
)
select w.country, num_of_ppl_wo_work_interest , num_of_respondent,
round(100.0* num_of_ppl_wo_work_interest / num_of_respondent,2) as percentage 
from num_of_ppl_no_work_interest as w
join num_of_respondents_per_country as r
on w.country = r.country 
order by percentage desc; 

-- 34.What is the relationship between mood swings and growing stress levels?
select mood_swings, growing_stress,
	round(100.0*count(*)/ sum(count(*)) over (partition by mood_swings),2) as percentage 
from mental_health
group by mood_swings, growing_stress 
order by percentage desc; 

-- 35.Do respondents who report changes in habits also report increased stress?
select changes_habits, growing_stress, count(*) as num_of_respondents,
	round(100.0*count(*) / sum(count(*)) over (partition by changes_habits),2) as percentage 
from mental_health
where changes_habits = 'Yes'
group by changes_habits, growing_stress; 

-- 36.Which occupations report the highest levels of social weakness?
with social_weakness as (
	select occupation, count(*) as num_of_social_weakness
	from mental_health
	where social_weakness = 'Yes'
	group by occupation
),
respondents_by_occupation as (
	select occupation, count(*) as num_of_respondents
	from mental_health
	group by occupation
)
select s.occupation, num_of_social_weakness, num_of_respondents,
	round(100.0*num_of_social_weakness/ num_of_respondents,2) as percentage 
from social_weakness as s
join respondents_by_occupation as r
on s.occupation = r.occupation 
order by percentage desc; 

-- 37.How does care option availability correlate with respondents’ willingness for interviews?
select care_options, mental_health_interview, count(*) as num_of_respondents,
	round(100.0*count(*)/ sum(count(*)) over (partition by care_options),2) as percentage
from mental_health
group by care_options, mental_health_interview 
order by care_options desc, percentage desc; 

-- 38.Are there differences in coping struggles based on days spent indoors?
-- select * from mental_health

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