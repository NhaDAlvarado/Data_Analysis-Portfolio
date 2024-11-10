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
from customerchurn;

-- 7.What is the relationship between NumOfProducts and churn rate?
select numofproducts, count(*) as num_churn_users 
from customerchurn
where exited is true
group by numofproducts
order by num_churn_users desc; 

-- 8.Among customers with the highest account balances, what percentage have churned?
with users_in_balance_group as (
	select (case when balance > 50000 then 'high balances'
			else 'low balances'
		end) as balance_groups, count(*) as num_users
	from customerchurn 
	group by balance_groups 
),
churn_user_in_group as (
	select (case when balance > 50000 then 'high balances'
			else 'low balances'
		end) as balance_groups, count(*) as num_churn_users
	from customerchurn 
	where exited is true 
	group by balance_groups 
)
select ch.balance_groups, num_churn_users, num_users,
	round(100.0*num_churn_users/num_users,2) as percentage 
from users_in_balance_group as u
join churn_user_in_group as ch on u.balance_groups = ch.balance_groups;

-- 9.How does the churn rate vary between active and inactive members (IsActiveMember)?
select 
	round(100.0*(
		select count(*) from customerchurn where exited is true and isactivemember is true
	)/ sum(case when isactivemember is true then 1 else 0 end) 
	,2) as percentage_churn_active_user,
	round(100.0*(
		select count(*) from customerchurn where exited is true and isactivemember is false 
	)/sum(case when isactivemember is false then 1 else 0 end )
	,2) as percentage_churn_nonactive_user
from customerchurn;

-- 10.What is the average EstimatedSalary for churned versus retained customers?
select 
	round(sum(case when exited is true then estimatedsalary else 0 end)
	/ (select count(*) from customerchurn where exited is true) 
	,2) as churn_avg_estimatedsalary,
	round(sum(case when exited is false then estimatedsalary else 0 end)
	/ (select count(*) from customerchurn where exited is false) 
	,2) as not_churn_avg_estimatedsalary	
from customerchurn;

-- 11.Which age group has the highest churn rate?
select case when age between 15 and 25 then '15- 24'
			when age between 25 and 35 then '25- 34'
			when age between 35 and 45 then '35- 44'
			when age between 45 and 55 then '45- 54'
			when age between 55 and 65 then '55- 64'
			when age between 65 and 75 then '65- 74'
			when age between 75 and 85 then '75- 84'
			when age between 85 and 95 then '85- 94'
	else '95+' end as age_group,
	count(*) as num_churned_user
from customerchurn
where exited is true 
group by age_group
order by num_churned_user desc; 

-- 12.Is there a correlation between Tenure and churn rate?
with churn_users as (
	select tenure, count(*) as num_churned_users
	from customerchurn 
	where exited is true 
	group by tenure 
),
users_per_tenure as (
	select tenure, count(*) as num_users
	from customerchurn 
	group by tenure 
)
select ch.tenure, num_churned_users, num_users,
	round(100.0 * num_churned_users/num_users,2) as percentage
from churn_users as ch
join users_per_tenure as t on ch.tenure = t.tenure 
order by percentage desc; 

-- 13.Which combination of factors (e.g., age, geography, and number of products) has the highest churn rate?
select case when age between 15 and 25 then '15- 24'
			when age between 25 and 35 then '25- 34'
			when age between 35 and 45 then '35- 44'
			when age between 45 and 55 then '45- 54'
			when age between 55 and 65 then '55- 64'
			when age between 65 and 75 then '65- 74'
			when age between 75 and 85 then '75- 84'
			when age between 85 and 95 then '85- 94'
	else '95+' end as age_group, 
	geography, numofproducts,
    round(100.0 * sum(case when exited is true then 1 else 0 end) / count(*), 2) AS churn_rate
from customerchurn
group by  age_group, geography, numofproducts
order by  churn_rate desc, age_group, geography, numofproducts ;

-- 14.What is the average tenure of customers who have stayed versus those who have churned?
select exited,
	round(avg(tenure),2) as avg_tenure
from customerchurn
group by exited;

-- 15.How does the churn rate differ by gender?
with female_churn_rate as (
	select round(100.0*sum(case when exited is true then 1 else 0 end) 
		/ count(*),2) as female_churn_percentage
	from customerchurn
	where gender = 'Female'
),
male_churn_rate as (
	select round(100.0*sum(case when exited is true then 1 else 0 end) 
		/ count(*),2) as male_churn_percentage
	from customerchurn
	where gender = 'Male'
)
select female_churn_percentage, male_churn_percentage
from female_churn_rate
cross join male_churn_rate;

-- 16.What is the median credit score of customers who churned?
select percentile_cont(0.5) within group (order by creditscore) as median_credit_score
from customerchurn
where exited is true;

-- 17.Among customers with a low CreditScore, how many products are they most likely to have?
select case when creditscore < 601 then 'low credit score'
			else 'high credit score'
		end as credit_score_types,
	round(avg(numofproducts),2) as avg_products
from customerchurn
group by credit_score_types;

-- 18.What percentage of high-income customers (above a certain salary threshold) have churned?
select round(100.0* sum (case when estimatedsalary > 100000 and exited = true then 1 else 0 end)
		/ sum (case when estimatedsalary > 100000 then 1 else 0 end) ,2) as high_income_churn_percentage
from customerchurn;

-- 19.How does the average number of products differ between churned and retained customers?
select exited,
	round(avg(numofproducts),2) as avg_num_products
from customerchurn
group by exited; 

-- 20.Which geography has the highest average customer balance?
select geography, round(avg(balance),2) as avg_balance
from customerchurn
group by geography
order by avg_balance desc;

-- 21.What is the average tenure for customers who have stayed with the bank for over five years?
select round(avg(tenure),2) as avg_turn
from customerchurn
where tenure >5 and exited is false; 

-- 22.How many active customers (IsActiveMember) have a balance greater than the average balance?
select count(*) as num_of_cus
from customerchurn
where isactivemember = true and 
	balance > (select avg(balance) from customerchurn);

-- 23.What is the churn rate for each unique NumOfProducts count?
with num_users as (
	select numofproducts, count(*) as num_of_users 
	from customerchurn
	group by numofproducts
),
num_churn_users as (
	select numofproducts, count(*) as num_churned_users 
	from customerchurn
	where exited = true
	group by numofproducts
)
select ch.numofproducts, num_churned_users, num_of_users,
	round(100.0*num_churned_users/num_of_users,2) as percentage 
from num_users as u 
join num_churn_users as ch on u.numofproducts = ch.numofproducts;

-- 24.How does churn correlate with both credit score and age?
select case when age between 15 and 25 then '15- 24'
			when age between 25 and 35 then '25- 34'
			when age between 35 and 45 then '35- 44'
			when age between 45 and 55 then '45- 54'
			when age between 55 and 65 then '55- 64'
			when age between 65 and 75 then '65- 74'
			when age between 75 and 85 then '75- 84'
			when age between 85 and 95 then '85- 94'
	else '95+' end as age_group, 
	case when creditscore < 601 then 'low credit score'
			else 'high credit score'
		end as credit_score_types,
	count(*) as num_of_churn	
from customerchurn
where exited = true 
group by age_group, credit_score_types
order by age_group, credit_score_types;

-- 25.What is the most common age for churned customers?
select case when age between 15 and 25 then '15- 24'
			when age between 25 and 35 then '25- 34'
			when age between 35 and 45 then '35- 44'
			when age between 45 and 55 then '45- 54'
			when age between 55 and 65 then '55- 64'
			when age between 65 and 75 then '65- 74'
			when age between 75 and 85 then '75- 84'
			when age between 85 and 95 then '85- 94'
	else '95+' end as age_group, 
count(*) as num_of_churn	
from customerchurn
where exited = true 
group by age_group
order by num_of_churn desc; 

-- 26.How does churn rate vary by customer tenure bracket (e.g., 0-2 years, 3-5 years, etc.)?
with num_churn_user as (
	select case when tenure between 0 and 2 then '0-1 years'
				when tenure between 2 and 4 then '2-3 years'
				when tenure between 4 and 6 then '4-5 years'
				when tenure between 6 and 8 then '6-7 years'
				when tenure between 8 and 10 then '8-9 years'
				else '10+'
			end as tenure_bracket,
		count(*) as num_churn_users 
	from customerchurn
	where exited = true 
	group by tenure_bracket 
),
num_user as (
	select case when tenure between 0 and 2 then '0-1 years'
				when tenure between 2 and 4 then '2-3 years'
				when tenure between 4 and 6 then '4-5 years'
				when tenure between 6 and 8 then '6-7 years'
				when tenure between 8 and 10 then '8-9 years'
				else '10+'
			end as tenure_bracket,
		count(*) as num_users 
	from customerchurn
	group by tenure_bracket 
)
select ch.tenure_bracket, num_churn_users, num_users, 
	round(100.0*num_churn_users/num_users,2) as percentage
from num_churn_user as ch
join num_user as u on ch.tenure_bracket = u.tenure_bracket; 

-- 27.What percentage of customers with both a high balance and multiple products churned?
with num_of_churn as (
	select case when balance > 50000 then 'high balances'
				else 'low balances'
			end as balance_groups, 
		case when numofproducts > 1 then 'multi products'
				else 'single product '
			end as product_groups,
		count(*) as num_churn_users
		from customerchurn 
		where exited is true 
		group by balance_groups, product_groups 
),
num_users as (
	select case when balance > 50000 then 'high balances'
				else 'low balances'
			end as balance_groups, 
		case when numofproducts > 1 then 'multi products'
				else 'single product '
			end as product_groups,
		count(*) as num_users
		from customerchurn 
		group by balance_groups, product_groups 
)
select ch.balance_groups, ch.product_groups, num_churn_users, num_users, 
	round(100.0*num_churn_users/num_users,2) as percentage
from num_of_churn as ch
join num_users as u on ch.balance_groups = u.balance_groups 
	and  ch.product_groups = u.product_groups;

-- 28.Are customers with zero balance more likely to churn compared to those with a positive balance?
with num_user as (
	select case when balance = 0 then 'zero balance'
		else 'positive balance' end as balance_group,
		count(*) as num_user
	from customerchurn
	group by balance_group
),
num_churn_user as (
	select case when balance = 0 then 'zero balance'
		else 'positive balance' end as balance_group,
		count(*) as num_churn_user
	from customerchurn
	where exited = true
	group by balance_group
)
select ch.balance_group, num_churn_user, num_user,
	round(100.0*num_churn_user/num_user,2) as percentage
from num_churn_user as ch
join num_user as u on ch.balance_group = u.balance_group;

-- 29.Among customers with high credit scores, what is the most common number of products held?
select case when creditscore < 601 then 'low credit score'
			else 'high credit score'
		end as credit_score_types,
	numofproducts, count(*) as num_users
from customerchurn
where (case when creditscore < 601 then 'low credit score'
			else 'high credit score'
		end) = 'high credit score'
group by numofproducts, credit_score_types
order by num_users desc; 

-- 30.How does the average EstimatedSalary vary by geography?
select geography, round(avg(estimatedsalary),2) as avg_estimate_salary
from customerchurn
group by geography; 

-- 31.What is the average tenure of customers who hold only one product versus multiple products?
select case when numofproducts <= 1 then 'single product'
		else 'multi products'
	end as product_group,
round(avg(tenure),2) as avg_tenure 
from customerchurn 
group by product_group; 

-- 32.How many customers have both low credit scores and high account balances?
select case when creditscore < 601 then 'low credit score'
			else 'high credit score'
		end as credit_score_types,
		case when balance <= 50000 then 'low balance'
			else 'high balance' 
		end as balance_group,
		count(*) as num_churn_user
	from customerchurn
	where (case when creditscore < 601 then 'low credit score'
			else 'high credit score'
			end) = 'low credit score'
	and (case when balance <= 50000 then 'low balance'
		else 'high balance' end) = 'high balance'
	group by credit_score_types,balance_group;

-- 33.Among female customers, which age group has the highest churn rate?
with female_customer as (
	select * 
	from customerchurn
	where gender = 'Female'
),
churn_users as (
	select case when age between 15 and 25 then '15- 24'
				when age between 25 and 35 then '25- 34'
				when age between 35 and 45 then '35- 44'
				when age between 45 and 55 then '45- 54'
				when age between 55 and 65 then '55- 64'
				when age between 65 and 75 then '65- 74'
				when age between 75 and 85 then '75- 84'
				when age between 85 and 95 then '85- 94'
		else '95+' end as age_group, 
	count(*) as num_of_churn	
	from female_customer 
	where exited = true 
	group by age_group
),
num_users as (
	select case when age between 15 and 25 then '15- 24'
				when age between 25 and 35 then '25- 34'
				when age between 35 and 45 then '35- 44'
				when age between 45 and 55 then '45- 54'
				when age between 55 and 65 then '55- 64'
				when age between 65 and 75 then '65- 74'
				when age between 75 and 85 then '75- 84'
				when age between 85 and 95 then '85- 94'
		else '95+' end as age_group, 
	count(*) as num_users	
	from female_customer  
	group by age_group
)
select ch.age_group, num_of_churn, num_users,
	round(100.0* num_of_churn/num_users,2) as  percentage 
from churn_users as ch
join num_users as u on ch.age_group = u.age_group 
order by percentage desc; 

-- 34.Which age group has the highest balance on average?
select case when age between 15 and 25 then '15- 24'
				when age between 25 and 35 then '25- 34'
				when age between 35 and 45 then '35- 44'
				when age between 45 and 55 then '45- 54'
				when age between 55 and 65 then '55- 64'
				when age between 65 and 75 then '65- 74'
				when age between 75 and 85 then '75- 84'
				when age between 85 and 95 then '85- 94'
		else '95+' end as age_group, 
round(avg(balance),2) as avg_balance
from customerchurn
group by age_group 
order by avg_balance desc; 

-- 35.What is the churn rate among customers who have only been with the bank for one year?
select round(100.0*count(*)
	/(select count(*) from customerchurn where tenure =1)
	,2) as churn_rate
from customerchurn
where tenure =1 and exited = true; 

-- 36.Among customers with no credit card, how many are active members? 
select round(100.0*count(*)
	/(select count(*) from customerchurn where hascrcard = true)
	,2) as active_rate
from customerchurn
where hascrcard = true and exited = false; 

-- 37.What is the average credit score for each unique number of products?
select numofproducts, round(avg(creditscore),2) as avg_score
from customerchurn
group by numofproducts;

-- 38.What percentage of customers with a low tenure and low balance are active members? 
select case when tenure <=2 then 'low tenure'
			else 'high tenure'
		end as tenure_types,
		case when balance <= 50000 then 'low balance'
			else 'high balance' 
		end as balance_group,
		round(100.0*count(*)/(select count(*) from customerchurn),2) as percentage 
	from customerchurn
	where (case when tenure <=2 then 'low tenure'
			else 'high tenure'
		end) = 'low tenure'
	and (case when balance <= 50000 then 'low balance'
			else 'high balance' 
		end) = 'low balance'
	group by tenure_types,balance_group;

-- 39.What is the average age of customers who hold two products?
select round(avg(age),2) as avg_age 
from customerchurn 
where numofproducts = 2; 

-- 40.Among customers in each geography, which gender has a higher average balance?
select geography, gender, round(avg(balance),2) as avg_balance
from customerchurn
group by geography, gender
order by geography, avg_balance desc; 

-- 41.What is the most common tenure for customers who have high estimated salaries?
select tenure, 
	case when estimatedsalary > 50000 then 'high salary'
			else 'low salary'
		end as salary_group,
count(*) as num_user
from customerchurn 
where (case when estimatedsalary > 50000 then 'high salary'
			else 'low salary'
		end) = 'high salary'
group by tenure, salary_group
order by num_user desc; 

-- 42.What is the highest balance held by any customer, and did that customer churn?
select surname, gender, balance, exited
from customerchurn
order by balance desc 
limit 1; 
/* Lo has the highest balance, and he's still active */

-- 43.How does the average balance differ between customers with low, medium, and high estimated salaries?
select case when estimatedsalary < 50000 then 'low salary'
			when estimatedsalary >= 50000 and estimatedsalary < 110000 then 'medium salary'
			else 'high salary'
		end as salary_group,
round(avg(balance),2) as avg_balance
from customerchurn
group by salary_group
order by avg_balance desc; 

-- 44.What percentage of customers with high tenure (e.g., 10+ years) have left the bank?
-- select * from customerchurn

-- 45.How many customers with two or more products are inactive members?
-- 46.Among customers aged 50 and above, what is the average credit score?
-- 47.For customers who churned, what is the average number of products they held?
-- 48.How does churn rate compare between customers with high and low tenure who have a credit card?
-- 49.What is the median age of customers with high balances?
-- 50.Among customers with an average or below-average estimated salary, how many hold multiple products?
