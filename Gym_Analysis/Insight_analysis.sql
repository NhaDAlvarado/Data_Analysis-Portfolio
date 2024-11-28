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
-- select * from gym_members_exercise_tracking

-- 20.Which workout type requires the highest water intake on average?
-- 21.How does water intake correlate with BMI?
-- 22.What is the average fat percentage of gym members?
-- 23.What is the relationship between fat percentage and BMI?
-- 24.Which workout type burns the most calories on average?
-- 25.What is the average calories burned per hour for each workout type?
-- 26.How does fat percentage vary across different experience levels?
-- 27.What is the average workout frequency for each experience level?
-- 28.How does BMI vary across experience levels?
-- 29.What is the average session duration for beginners, intermediates, and advanced members?
-- 30.What is the relationship between experience level and calories burned?
-- 31.How does water intake differ by experience level?
-- 32.What is the average workout frequency for male and female members?
-- 33.How does BMI differ between male and female members?
-- 34.What is the average session duration for males vs. females?
-- 35.Which workout type is most popular among male members? Female members?
-- 36.How do resting BPM and maximum BPM differ between genders?
-- 37.How does workout frequency correlate with calories burned?
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