-- 1.What is the overall churn rate of customers?
select 
	round(100.0*count(*)/(select count(*) from customerchurn),2) as churn_percentage
from customerchurn
where exited is true; 

-- 2.How does churn rate vary by country (Geography)?
with num_of_churn as (
	select geography, 
		count(*) as num_of_churn_user 
	from customerchurn
	where exited is true 
	group by geography
), 
users_per_country as (
	select geography,
	count(*) as num_of_user
	from customerchurn
	group by geography 
)
select ch.geography, num_of_churn_user, num_of_user,
round(100.0* num_of_churn_user/num_of_user,2) as percentage
from num_of_churn as ch
join users_per_country as u on ch.geography = u.geography;

-- 3.What is the average credit score of customers who have churned versus those who have not?
select 
	round(sum(case when exited is true then creditscore else 0 end)
	/ (select count(*) from customerchurn where exited is true) 
	,2) as churn_avg_credit_score,
	round(sum(case when exited is false then creditscore else 0 end)
	/ (select count(*) from customerchurn where exited is false) 
	,2) as not_churn_avg_credit_score	
from customerchurn;

-- 4.Is there a significant difference in the average balance between customers who churned and those who stayed?
select 
	round(sum(case when exited is true then balance else 0 end)
	/ (select count(*) from customerchurn where exited is true) 
	,2) as churn_avg_balance,
	round(sum(case when exited is false then balance else 0 end)
	/ (select count(*) from customerchurn where exited is false) 
	,2) as not_churn_avg_balance	
from customerchurn;

-- 5.What is the distribution of churn across different age groups?
with count_churned_user as (
	select case when age between 15 and 25 then '15- 24'
				when age between 25 and 35 then '25- 34'
				when age between 35 and 45 then '35- 44'
				when age between 45 and 55 then '45- 54'
				when age between 55 and 65 then '55- 64'
				when age between 65 and 75 then '65- 74'
				when age between 75 and 85 then '75- 84'
				when age between 85 and 95 then '85- 94'
		else '95+'
		end as age_group,
		count(*) as num_churn_user
	from customerchurn
	where exited is true
	group by age_group 
),
num_user_per_age_group as (
	select case when age between 15 and 25 then '15- 24'
				when age between 25 and 35 then '25- 34'
				when age between 35 and 45 then '35- 44'
				when age between 45 and 55 then '45- 54'
				when age between 55 and 65 then '55- 64'
				when age between 65 and 75 then '65- 74'
				when age between 75 and 85 then '75- 84'
				when age between 85 and 95 then '85- 94'
		else '95+'
		end as age_group,
		count(*) as num_user
	from customerchurn
	group by age_group
)
select ch.age_group, num_churn_user, num_user,
	round(100.0*num_churn_user/num_user,2) as churn_percentage 
from count_churned_user as ch
join num_user_per_age_group as a on ch.age_group = a.age_group 
order by age_group; 

-- 6.How does churn rate differ between customers who have a credit card versus those who do not (HasCrCard)?
select 
	round(100.0*(
		select count(*) from customerchurn where exited is true and hascrcard is true
	)/ sum(case when hascrcard is true then 1 else 0 end) 
	,2) as percentage_churn_user_with_cr,
	round(100.0*(
		select count(*) from customerchurn where exited is true and hascrcard is false 
	)/sum(case when hascrcard is false then 1 else 0 end )
	,2) as percentage_churn_user_wo_cr
from customerchurn

-- 7.What is the relationship between NumOfProducts and churn rate?
-- select * from customerchurn

-- 8.Among customers with the highest account balances, what percentage have churned?
-- 9.How does the churn rate vary between active and inactive members (IsActiveMember)?
-- 10.What is the average EstimatedSalary for churned versus retained customers?
-- 11.Which age group has the highest churn rate?
-- 12.Is there a correlation between Tenure and churn rate?
-- 13.Which combination of factors (e.g., age, geography, and number of products) has the highest churn rate?
-- 14.What is the average tenure of customers who have stayed versus those who have churned?
-- 15.How does the churn rate differ by gender?
-- 16.What is the median credit score of customers who churned?
-- 17.Among customers with a low CreditScore, how many products are they most likely to have?
-- 18.What percentage of high-income customers (above a certain salary threshold) have churned?
-- 19.How does the average number of products differ between churned and retained customers?
-- 20.Which geography has the highest average customer balance?
-- 21.What is the average tenure for customers who have stayed with the bank for over five years?
-- 22.How many active customers (IsActiveMember) have a balance greater than the average balance?
-- 23.What is the churn rate for each unique NumOfProducts count?
-- 24.How does churn correlate with both credit score and age?
-- 25.What is the most common age for churned customers?
-- 26.How does churn rate vary by customer tenure bracket (e.g., 0-2 years, 3-5 years, etc.)?
-- 27.What percentage of customers with both a high balance and multiple products churned?
-- 28.Are customers with zero balance more likely to churn compared to those with a positive balance?
-- 29.Among customers with high credit scores, what is the most common number of products held?
-- 30.How does the average EstimatedSalary vary by geography?
-- 31.What is the average tenure of customers who hold only one product versus multiple products?
-- 32.How many customers have both low credit scores and high account balances?
-- 33.Among female customers, which age group has the highest churn rate?
-- 34.Which age group has the highest balance on average?
-- 35.What is the churn rate among customers who have only been with the bank for one year?
-- 36.Among customers with no credit card, how many are active members?
-- 37.What is the average credit score for each unique number of products?
-- 38.What percentage of customers with a low tenure and low balance are active members?
-- 39.What is the average age of customers who hold two products?
-- 40.Among customers in each geography, which gender has a higher average balance?
-- 41.What is the most common tenure for customers who have high estimated salaries?
-- 42.What is the highest balance held by any customer, and did that customer churn?
-- 43.How does the average balance differ between customers with low, medium, and high estimated salaries?
-- 44.What percentage of customers with high tenure (e.g., 10+ years) have left the bank?
-- 45.How many customers with two or more products are inactive members?
-- 46.Among customers aged 50 and above, what is the average credit score?
-- 47.For customers who churned, what is the average number of products they held?
-- 48.How does churn rate compare between customers with high and low tenure who have a credit card?
-- 49.What is the median age of customers with high balances?
-- 50.Among customers with an average or below-average estimated salary, how many hold multiple products?