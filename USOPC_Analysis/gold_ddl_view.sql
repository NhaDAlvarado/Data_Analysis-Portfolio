drop view if exists gold.SportBenefitsStatementsDataByYear;
create view gold.SportBenefitsStatementsDataByYear as 
	select 
		NGB,
		Olympic_Paralympic_PanAmerican,
		Num_Events_At_Games,
		NCAA_Sport,
		Year,
		Athlete_360,
		Athlete_Stipends,
		Coaching_Education,
		COVID_Athlete_Assistance_Fund,
		Elite_Athlete_Health_Insurance,
		High_Performance_Grants,
		High_Performance_Special_Grants,
		National_Medical_Network,
		NGB_HPMO_COVID_Grants,
		Operation_Gold,
		Paralympic_Sport_Development_Grants,
		Restricted_Grants,
		Sport_Science_Services,
		Sports_Medicine_Clinics,
		Facilities_Chula_Vista_California,
		Facilities_Colorado_Springs_Colorado,
		Facilities_Lake_Placid_New_York,
		Facilities_Salt_Lake_City_Utah
	from silver.SportBenefitsStatementsDataByYear;

drop view if exists gold.NGBHealthDataOutputExtract;
create view gold.NGBHealthDataOutputExtract as 
	select 
		Overall_Parent_NGB,
		Overall_Year,
		Financial_Year,
		case when Membership_Bucket =1 then '> 100,000'
			when Membership_Bucket =2 then '30,000-100,000'
			when Membership_Bucket =3 then '10,000-30,000'
			when Membership_Bucket =4 then '< 10,000'
			else 'n/a'
		end as Membership_Bucket_Def,

		case when Revenue_Bucket =1 then '> $20M'
			when Revenue_Bucket =2 then '$10M-$20M'
			when Revenue_Bucket =3 then '$2M-$10M'
			when Revenue_Bucket =4 then '< $2M'
			else 'n/a'
		end as Revenue_Bucket_Def,
	
		case when Staff_Bucket = 1 then '> 100'
			when Staff_Bucket = 2 then '30-100'	
			when Staff_Bucket = 3 then '10-30'
			when Staff_Bucket = 4 then '< 10'
			else 'n/a'
		end as Staff_Bucket_Def,
		CEO_Salary,
		Membership_Bucket,
		Membership_Size,
		Revenue_Bucket,
		Staff_Bucket,
		Staff_Size,
		Total_Expenses,
		Total_Revenue
	from silver.NGBHealthDataOutputExtract;
