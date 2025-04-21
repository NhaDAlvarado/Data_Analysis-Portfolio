-- DATA DEFINITION LANGUAGE DEFINES THE STRUCTURE OF DATABASE TABLES
-- bronze schema

drop table if exists bronze.SportBenefitsStatementsDataByYear;
create table bronze.SportBenefitsStatementsDataByYear (
	NGB text,
	Olympic_Paralympic_PanAmerican text,
	Num_Events_At_Games int,
	NCAA_Sport varchar(50),
	Year int,
	Athlete_360 text,
	Athlete_Stipends text,
	Coaching_Education text,
	COVID_Athlete_Assistance_Fund text,
	Elite_Athlete_Health_Insurance text,
	High_Performance_Grants text,
	High_Performance_Special_Grants text,
	National_Medical_Network text,
	NGB_HPMO_COVID_Grants text,
	Operation_Gold text,
	Paralympic_Sport_Development_Grants text,
	Restricted_Grants text,
	Sport_Science_Services text,
	Sports_Medicine_Clinics text,
	Facilities_Chula_Vista_California text,
	Facilities_Colorado_Springs_Colorado text,
	Facilities_Lake_Placid_New_York text,
	Facilities_Salt_Lake_City_Utah text	
);

drop table if exists bronze.NGBHealthDataOutputExtract;
create table bronze.NGBHealthDataOutputExtract (
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
	Total_Revenue int
);
