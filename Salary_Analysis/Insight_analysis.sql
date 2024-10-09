-- 1. What is the average salary by job title?
select job_title, round(avg(salary)) as avg_salary
from employee_data 
where salary is not null 
group by job_title
order by avg_salary desc; 

-- 2. What is the distribution of education levels among employees?
select education_level,
	round(100.0*count(education_level)/ (select count(*) from employee_data),2) as percentage
from employee_data
group by education_level;

-- 3. How does salary vary with years of experience?
with categorize_level as (
	select salary, years_of_experience,
		(case 
			when years_of_experience <2 then 'Junior'
			when years_of_experience between 2 and 5 then 'Associate'
			when years_of_experience between 5 and 10 then 'Mid Level'
			else 'Senior'
		end) as experience_level
	from employee_data
)
select experience_level,
	min(salary) || ' - ' || max(salary) as sal_range
from categorize_level
group by experience_level;

-- 4. What is the gender distribution across different job titles?
with gender_count as (
	select job_title,
		sum(case when gender = 'Male' then 1 else 0 end) as male_count,
		sum(case when gender = 'Female' then 1 else 0 end) as female_count
	from employee_data
	group by job_title
),
total_emp_per_title as (
	select job_title, count(*) as total_emp
	from employee_data
	group by job_title
)
select g.job_title, 
	round(100.0* female_count/total_emp) as female_dis,
	round(100.0* male_count/total_emp) as male_dis	
from gender_count as g
join total_emp_per_title as t on g.job_title = t.job_title;

-- 5. Which job titles have the highest and lowest average years of experience?
with avg_yoe as (
	select job_title, round(avg(years_of_experience)) as avg_yoe,
	dense_rank() over (order by avg(years_of_experience) desc) as rank
	from employee_data
	group by job_title
)
select job_title, avg_yoe 
from avg_yoe
where rank = 1 or rank = 108

-- 6. Is there a correlation between age and salary?


-- 7. What is the average salary for each education level?
-- 8. How many employees have more than 10 years of experience, and what are their job titles?
-- 9. What is the total salary expenditure by job title?
-- 10. What is the distribution of employees' age across different job titles?
-- 11. Which gender has a higher average salary across different job titles?
-- 12. How many employees with a PhD have a salary greater than $100,000?
-- 13. What is the average number of years of experience for employees with a salary greater than $100,000?
-- 14. How does the average salary differ between males and females across different education levels?
-- 15. What is the most common job title among employees with a Master’s degree?
-- 16. What is the salary range for employees under 30 years old?
-- 17. How many employees have salaries in the top 10% of the dataset?
-- 18. Which job titles have the highest concentration of employees with less than 5 years of experience?
-- 19. What is the salary distribution for employees aged over 40?
-- 20. How does the salary compare for employees with the same job title but different education levels?

