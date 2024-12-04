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

-- 20.Which workout type requires the highest water intake on average?
select workout_type, round(avg(water_intake_liters)::numeric,2) as avg_intake
from gym_members_exercise_tracking
group by workout_type 
order by avg_intake desc; 

-- 21.How does water intake correlate with BMI?
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

-- 22.What is the average fat percentage of gym members?
select round(avg(fat_percentage)::numeric,2) as avg_fat_percentage 
from gym_members_exercise_tracking; 

-- 23.What is the relationship between fat percentage and BMI?
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

-- 24.Which workout type burns the most calories on average?
select workout_type, round(avg(calories_burned)::numeric,2) as avg_burned 
from gym_members_exercise_tracking
group by workout_type
order by avg_burned desc; 

-- 25.What is the average calories burned per hour for each workout type?
select workout_type, round(avg(calories_burned/session_duration_hours)::numeric,2) as avg_burned 
from gym_members_exercise_tracking
group by workout_type
order by avg_burned desc; 

-- 26.How does fat percentage vary across different experience levels?
select experience_level,
	round(avg(fat_percentage)::numeric,2) as avg_fat_percentage
from gym_members_exercise_tracking 
group by experience_level
order by avg_fat_percentage desc; 

-- 27.What is the average workout frequency for each experience level?
select experience_level,
	round(avg(workout_frequency_days_per_week)::numeric,2) as avg_frequency
from gym_members_exercise_tracking 
group by experience_level
order by avg_frequency desc; 

-- 28.How does BMI vary across experience levels?
select
	experience_level,
	round(avg(bmi)::numeric,2) as avg_bmi
from gym_members_exercise_tracking 
group by experience_level
order by avg_bmi desc; 

-- 29.What is the average session duration for beginners, intermediates, and advanced members?
select
	experience_level,
	round(avg(session_duration_hours)::numeric,2) as avg_session
from gym_members_exercise_tracking 
group by experience_level
order by avg_session desc; 

-- 30.What is the relationship between experience level and calories burned?
select
	experience_level,
	round(avg(calories_burned)::numeric,2) as avg_calories_burned
from gym_members_exercise_tracking 
group by experience_level
order by avg_calories_burned desc; 

-- 31.How does water intake differ by experience level?
select
	experience_level,
	round(avg(water_intake_liters)::numeric,2) as avg_water_intake
from gym_members_exercise_tracking 
group by experience_level
order by avg_water_intake desc; 

-- 32.What is the average workout frequency for male and female members?
select
	gender,
	round(avg(workout_frequency_days_per_week)::numeric,2) as avg_frequency
from gym_members_exercise_tracking 
group by gender 
order by avg_frequency desc; 

-- 33.How does BMI differ between male and female members?
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

-- 34.What is the average session duration for males vs. females?
select gender, round(avg(session_duration_hours)::numeric,2) as avg_session
from gym_members_exercise_tracking
group by gender;

-- 35.Which workout type is most popular among male members? Female members?
select gender, workout_type, count(*) as num_members,
	round(100.0*count(*) / sum(count(*)) over (partition by gender) ,2) as percentage 
from gym_members_exercise_tracking
group by gender, workout_type
order by gender, percentage desc;

-- 36.How do resting BPM and maximum BPM differ between genders?
select gender, round(avg(max_bpm)::numeric,2) as avg_max_bpm,
	round(avg(resting_bpm)::numeric,2) as avg_resting_bpm
from gym_members_exercise_tracking
group by gender;

-- 37.How does workout frequency correlate with calories burned?
-- select * from gym_members_exercise_tracking

-- 38.What is the relationship between session duration and calories burned?
-- 39.How does BMI influence workout frequency?
-- 40.What is the relationship between fat percentage and workout type?
-- 41.How does water intake correlate with session duration?
-- 42.What is the average calories burned per unit of water intake for each workout type?
-- 43.Which workout type yields the best calorie-to-duration ratio?
-- 44.What is the average time spent per workout type by experience level?
-- 45.How does workout frequency affect BMI over time?
-- 46.What is the difference in average calories burned between male and female members?
-- 47.What percentage of members perform HIIT workouts?
-- 48.How does average session duration differ by age group?
-- 49.Which workout type is preferred by members with high BMI?
-- 50.How does resting BPM vary with workout frequency?
-- 50.What is the correlation between maximum BPM and calories burned?