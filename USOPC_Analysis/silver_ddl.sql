-- DATA DEFINITION LANGUAGE DEFINES THE STRUCTURE OF DATABASE TABLES
-- silver schema

drop table if exists silver.SportBenefitsStatementsDataByYear;
create table silver.SportBenefitsStatementsDataByYear (
	NGB text,
	Olympic_Paralympic_PanAmerican text,
	Num_Events_At_Games int,
	NCAA_Sport varchar(50),
	Year int,
	Athlete_360 float,
	Athlete_Stipends float,
	Coaching_Education float,
	COVID_Athlete_Assistance_Fund float,
	Elite_Athlete_Health_Insurance float,
	High_Performance_Grants float,
	High_Performance_Special_Grants float,
	National_Medical_Network float,
	NGB_HPMO_COVID_Grants float,
	Operation_Gold float,
	Paralympic_Sport_Development_Grants float,
	Restricted_Grants float,
	Sport_Science_Services float,
	Sports_Medicine_Clinics float,
	Facilities_Chula_Vista_California float,
	Facilities_Colorado_Springs_Colorado float,
	Facilities_Lake_Placid_New_York float,
	Facilities_Salt_Lake_City_Utah float,
	uspoc_create_date timestamp default current_timestamp
);

drop table if exists silver.NGBHealthDataOutputExtract;
create table silver.NGBHealthDataOutputExtract (
	Overall_Parent_NGB text,
	Overall_Year int,
	Financial_Year text,
	Membership_Bucket_Def text,
	Revenue_Bucket_Def text,
	Staff_Bucket_Def text,
	CEO_Salary int,
	Membership_Bucket int,
	Membership_Size int,
	Revenue_Bucket int,
	Staff_Bucket int,
	Staff_Size int,
	Total_Expenses int,
	Total_Revenue int,
	ucpoc_create_date timestamp default current_timestamp
);
