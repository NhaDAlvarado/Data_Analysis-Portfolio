-- 1.What is the average age of gym members?
select round(avg(age),2) as avg_age
from gym_members_exercise_tracking;

-- 2.How many male and female gym members are there?
select gender, count(*) as num_of_members
from gym_members_exercise_tracking
group by gender; 

-- 3.What is the average BMI of gym members?
select round(avg(bmi):: numeric,2) as avg_bmi
from gym_members_exercise_tracking;

-- 4.What is the distribution of gym members across different experience levels?
select experience_level, 
	round(100.0*count(*)/(select count(*) from gym_members_exercise_tracking),2) as percentage
from gym_members_exercise_tracking
group by experience_level;

-- 5.What is the average weight and height of gym members by gender?
select gender, round(avg(weight_kg)::numeric,2) as avg_weight, round(avg(height_m)::numeric,2) as avg_height
from gym_members_exercise_tracking
group by gender; 

-- 6.What is the most common workout type among members?
select workout_type, count(*) as num_of_member
from gym_members_exercise_tracking
group by workout_type
order by num_of_member desc; 

-- 7.What is the average session duration for each workout type?
select workout_type, round(avg(session_duration_hours)::numeric,2) as avg_duration
from gym_members_exercise_tracking
group by workout_type; 

-- 8.How does workout frequency vary across experience levels?
select experience_level, workout_frequency_days_per_week, count(*) as num_of_member
from gym_members_exercise_tracking
group by workout_frequency_days_per_week, experience_level
order by experience_level , workout_frequency_days_per_week;

-- 9.What is the average calories burned for each workout type?
select workout_type, round(avg(calories_burned)::numeric,2) as avg_cal_burn
from gym_members_exercise_tracking
group by workout_type
order by avg_cal_burn desc; 

-- 10.What is the maximum session duration recorded in the dataset?
select max(session_duration_hours) as max_session_duration
from gym_members_exercise_tracking;

-- 11.What is the average resting BPM for all members?
select round(avg(resting_bpm)::numeric,2) as avg_resting_bpm
from gym_members_exercise_tracking;

-- 12.What is the average maximum BPM during workouts?
select round(avg(max_bpm)::numeric,2) as avg_max_bpm
from gym_members_exercise_tracking;

-- 13.How does average BPM during workouts vary across different workout types?
select workout_type,round(avg(avg_bpm),2) as avg_bpm
from gym_members_exercise_tracking
group by workout_type;

-- 14.What is the difference between resting BPM and average BPM during sessions?
select resting_bpm,
    avg_bpm,
    (avg_bpm - resting_bpm) AS BPM_Difference
from gym_members_exercise_tracking;

-- 15.What is the correlation between resting BPM and BMI?
select corr(resting_bpm, bmi) as corr_bpm_bmi
from gym_members_exercise_tracking;

-- 16.What is the average water intake of members during workouts?
select round(avg(water_intake_liters)::numeric,2) as avg_intake
from gym_members_exercise_tracking;

-- 17.How does water intake vary by workout frequency?
select workout_frequency_days_per_week, round(avg(water_intake_liters)::numeric,2) as avg_intake
from gym_members_exercise_tracking
group by workout_frequency_days_per_week;

-- 18.What is the relationship between water intake and calories burned?
select case when calories_burned between 0 and 300 then 'low' 
	when calories_burned between 301 and 800 then 'medium' 
	when calories_burned between 801 and 1200 then 'high' 
	else 'super'
	end as calories_groups,
	case 
		when water_intake_liters between 0 and 1 then '0-1 litter'
		when water_intake_liters between 1 and 2 then '1-2 litters'
		when water_intake_liters between 2 and 3 then '2-3 litters'
		when water_intake_liters between 3 and 4 then '3-4 litters'
		else 'other'
	end as water_groups,
	count(*) as num_of_members,
	round(100.0*count(*)/ sum(count(*)) over (partition by 
	case 
		when calories_burned between 0 and 300 then 'low' 
		when calories_burned between 301 and 800 then 'medium' 
		when calories_burned between 801 and 1200 then 'high' 
		else 'super'
	end ),2) as percentages
from gym_members_exercise_tracking
group by calories_groups, water_groups
order by calories_groups, water_groups;  

-- 19.Which workout type requires the highest water intake on average?
select workout_type, round(avg(water_intake_liters)::numeric,2) as avg_intake
from gym_members_exercise_tracking
group by workout_type 
order by avg_intake desc; 

-- 20.How does water intake correlate with BMI?
select
	case 
		when bmi < 18.5 then 'Underweight'
		when bmi between 18.5 and 24.99 then 'Healthy weight'
		when bmi between 25 and 29.99 then 'Overweight'
		when bmi > 30 then 'Obesity'
	end as bmi_range,
	round(avg(water_intake_liters)::numeric,2) as avg_intakes
from gym_members_exercise_tracking 
group by bmi_range
order by avg_intakes desc; 

-- 21.What is the average fat percentage of gym members?
select round(avg(fat_percentage)::numeric,2) as avg_fat_percentage 
from gym_members_exercise_tracking; 

-- 22.What is the relationship between fat percentage and BMI?
select
	case 
		when bmi < 18.5 then 'Underweight'
		when bmi between 18.5 and 24.99 then 'Healthy weight'
		when bmi between 25 and 29.99 then 'Overweight'
		when bmi > 30 then 'Obesity'
	end as bmi_range,
	round(avg(fat_percentage)::numeric,2) as avg_fat_percentage
from gym_members_exercise_tracking 
group by bmi_range
order by avg_fat_percentage desc; 

-- 23.Which workout type burns the most calories on average?
select workout_type, round(avg(calories_burned)::numeric,2) as avg_burned 
from gym_members_exercise_tracking
group by workout_type
order by avg_burned desc; 

-- 24.What is the average calories burned per hour for each workout type?
select workout_type, round(avg(calories_burned/session_duration_hours)::numeric,2) as avg_burned 
from gym_members_exercise_tracking
group by workout_type
order by avg_burned desc; 

-- 25.How does fat percentage vary across different experience levels?
select experience_level,
	round(avg(fat_percentage)::numeric,2) as avg_fat_percentage
from gym_members_exercise_tracking 
group by experience_level
order by avg_fat_percentage desc; 

-- 26.What is the average workout frequency for each experience level?
select experience_level,
	round(avg(workout_frequency_days_per_week)::numeric,2) as avg_frequency
from gym_members_exercise_tracking 
group by experience_level
order by avg_frequency desc; 

-- 27.How does BMI vary across experience levels?
select
	experience_level,
	round(avg(bmi)::numeric,2) as avg_bmi
from gym_members_exercise_tracking 
group by experience_level
order by avg_bmi desc; 

-- 28.What is the average session duration for beginners, intermediates, and advanced members?
select
	experience_level,
	round(avg(session_duration_hours)::numeric,2) as avg_session
from gym_members_exercise_tracking 
group by experience_level
order by avg_session desc; 

-- 29.What is the relationship between experience level and calories burned?
select
	experience_level,
	round(avg(calories_burned)::numeric,2) as avg_calories_burned
from gym_members_exercise_tracking 
group by experience_level
order by avg_calories_burned desc; 

-- 30.How does water intake differ by experience level?
select
	experience_level,
	round(avg(water_intake_liters)::numeric,2) as avg_water_intake
from gym_members_exercise_tracking 
group by experience_level
order by avg_water_intake desc; 

-- 31.What is the average workout frequency for male and female members?
select
	gender,
	round(avg(workout_frequency_days_per_week)::numeric,2) as avg_frequency
from gym_members_exercise_tracking 
group by gender 
order by avg_frequency desc; 

-- 32.How does BMI differ between male and female members?
select gender,
	case 
		when bmi < 18.5 then 'Underweight'
		when bmi between 18.5 and 24.99 then 'Healthy weight'
		when bmi between 25 and 29.99 then 'Overweight'
		when bmi > 30 then 'Obesity'
	end as bmi_range,
	count(*) as num_of_memebers,
	round(100.0*count(*)/sum(count(*)) over (partition by gender),2) as percentage
from gym_members_exercise_tracking 
group by bmi_range, gender
order by gender; 

-- 33.What is the average session duration for males vs. females?
select gender, round(avg(session_duration_hours)::numeric,2) as avg_session
from gym_members_exercise_tracking
group by gender;

-- 34.Which workout type is most popular among male members? Female members?
select gender, workout_type, count(*) as num_members,
	round(100.0*count(*) / sum(count(*)) over (partition by gender) ,2) as percentage 
from gym_members_exercise_tracking
group by gender, workout_type
order by gender, percentage desc;

-- 35.How do resting BPM and maximum BPM differ between genders?
select gender, round(avg(max_bpm)::numeric,2) as avg_max_bpm,
	round(avg(resting_bpm)::numeric,2) as avg_resting_bpm
from gym_members_exercise_tracking
group by gender;

-- 36.How does workout frequency correlate with calories burned?
select workout_frequency_days_per_week, round(avg(calories_burned)::numeric,2) as avg_burned
from gym_members_exercise_tracking
group by workout_frequency_days_per_week
order by avg_burned desc; 

-- 37.What is the relationship between session duration and calories burned?
select case 
	when session_duration_hours between 0.5 and 1 then '30 - 60 mins'
	when session_duration_hours between 1 and 1.5 then '61 - 90 mins'
	when session_duration_hours between 1.5 and 2 then '91 - 120 mins'
	end as session_ranges,
	round(avg(calories_burned)::numeric,2) as avg_burned
from gym_members_exercise_tracking
group by session_ranges
order by avg_burned desc; 

-- 38.How does BMI influence workout frequency?
with bmi_range as (
	select case 
			when bmi < 18.5 then 'Underweight'
			when bmi between 18.5 and 24.99 then 'Healthy weight'
			when bmi between 25 and 29.99 then 'Overweight'
			when bmi > 30 then 'Obesity'
		end as bmi_range,
		workout_frequency_days_per_week,
		count(*) as num_of_members
	from gym_members_exercise_tracking 
	group by bmi_range, workout_frequency_days_per_week
)
select bmi_range, workout_frequency_days_per_week as days_per_week, num_of_members,
	round(100.0* num_of_members/sum(num_of_members) over (partition by bmi_range),2) as percentage
from bmi_range
order by bmi_range, percentage desc ; 

-- 39.What is the relationship between fat percentage and workout type?
select workout_type, round(avg(fat_percentage)::numeric,2) as avg_fat
from gym_members_exercise_tracking
group by workout_type 
order by avg_fat desc; 

-- 40.How does water intake correlate with session duration?
select case 
	when session_duration_hours between 0.5 and 1 then '30 - 60 mins'
	when session_duration_hours between 1 and 1.5 then '61 - 90 mins'
	when session_duration_hours between 1.5 and 2 then '91 - 120 mins'
	end as session_ranges,
	round(avg(water_intake_liters)::numeric,2) as avg_intakes
from gym_members_exercise_tracking
group by session_ranges
order by avg_intakes desc; 

-- 41.What is the average calories burned per unit of water intake for each workout type?
select workout_type,
    round(avg(calories_burned / water_intake_liters)::numeric,2) AS avg_calories_per_unit_water
from gym_members_exercise_tracking
group by workout_type
order by avg_calories_per_unit_water desc;

-- 42.Which workout type yields the best calorie-to-duration ratio?
select workout_type,
    round(avg(calories_burned / session_duration_hours)::numeric,2) AS avg_calorie_to_duration
from gym_members_exercise_tracking
group by workout_type
order by avg_calorie_to_duration desc;

-- 43.What is the average time spent per workout type by experience level?
select workout_type, experience_level, round(avg(session_duration_hours)::numeric,2) AS avg_duration 
from gym_members_exercise_tracking
group by workout_type, experience_level
order by workout_type, experience_level;

-- 44.How does workout frequency affect BMI over time?
select workout_frequency_days_per_week, round(avg(bmi)::numeric,2) as avg_bmi
from gym_members_exercise_tracking
group by workout_frequency_days_per_week
order by avg_bmi desc; 

-- 45.What is the difference in average calories burned between male and female members?
select gender, round(avg(calories_burned)::numeric,2) as avg_burned
from gym_members_exercise_tracking
group by gender 
order by avg_burned desc; 

-- 46.What percentage of members perform HIIT workouts?
select workout_type, 
	round(100.0* count(*)/(select count(*) from gym_members_exercise_tracking),2) as percentage
from gym_members_exercise_tracking
group by workout_type; 

-- 47.How does average session duration differ by age group?
select case 
	when age between 18 and 25 then '18-25'
	when age between 26 and 35 then '26-35'
	when age between 36 and 45 then '36-45'
	when age between 46 and 55 then '46-55'
	when age between 56 and 65 then '56-65'
	end as age_group,
	round(avg(session_duration_hours)::numeric,2) as avg_duration	
from gym_members_exercise_tracking
group by age_group;

-- 48.Which workout type is preferred by members with high BMI?
with bmi_range as (
	select case 
			when bmi < 18.5 then 'Underweight'
			when bmi between 18.5 and 24.99 then 'Healthy weight'
			when bmi > 25 then 'Overweight'
		end as bmi_range,
	workout_type, 
	count(*) as num_of_members
from gym_members_exercise_tracking
group by bmi_range, workout_type 
)
select workout_type, num_of_members
from bmi_range
where bmi_range = 'Overweight'
order by num_of_members desc; 

-- 49.How does resting BPM vary with workout frequency?
select workout_frequency_days_per_week, round(avg(resting_bpm)::numeric,2) as avg_rest_bpm
from gym_members_exercise_tracking
group by workout_frequency_days_per_week
order by avg_rest_bpm desc; 

-- 50.What is the correlation between maximum BPM and calories burned?
select corr(max_bpm, calories_burned) as correlation
from gym_members_exercise_tracking
-- result is 0.0021 is near to 0 so there is no correlation


