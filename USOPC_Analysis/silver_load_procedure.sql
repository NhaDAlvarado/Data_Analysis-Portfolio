DROP PROCEDURE IF EXISTS silver.silver_load;

CREATE PROCEDURE silver.silver_load()
LANGUAGE plpgsql
AS $$
DECLARE 
	start_time timestamp;
	end_time timestamp;
	batch_start_time TIMESTAMP;
    batch_end_time TIMESTAMP;
BEGIN
	batch_start_time := clock_timestamp();
	RAISE NOTICE '================================';
    RAISE NOTICE 'Loading Silver Layer';
    RAISE NOTICE '================================';

	RAISE NOTICE '--------------------------------';
    RAISE NOTICE 'Loading SportBenefitsStatementsDataByYear tables';
    RAISE NOTICE '--------------------------------';
	
	BEGIN
		RAISE NOTICE '>> Truncating table: silver.SportBenefitsStatementsDataByYear';
		TRUNCATE TABLE silver.SportBenefitsStatementsDataByYear RESTART IDENTITY;
		RAISE NOTICE '>> Inserting data into silver.SportBenefitsStatementsDataByYear';
		start_time := clock_timestamp();
		insert into silver.SportBenefitsStatementsDataByYear (
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
		)
		select NGB,
			Olympic_Paralympic_PanAmerican,
			Num_Events_At_Games,
			NCAA_Sport,
			Year,
			-- trim $ and ',' signs then change athelete_360 type from text to float
			(case 
				when trim(Athlete_360)like '%-' then '0'
				else trim(replace(substring(Athlete_360 from 2 for length(Athlete_360)),',',''))
			end)::numeric as Athlete_360,
			
			-- trim $ and ',' signs then change Athlete_Stipends type from text to float
			(case 
				when trim(Athlete_Stipends)like '%-' then '0'
				else trim(replace(substring(Athlete_Stipends from 2 for length(Athlete_Stipends)),',',''))
			end)::numeric as Athlete_Stipends,
		
			-- trim $ and ',' signs then change Coaching_Education type from text to float
			(case 
				when trim(Coaching_Education)like '%-' then '0'
				else trim(replace(substring(Coaching_Education from 2 for length(Coaching_Education)),',',''))
			end)::numeric as Coaching_Education,
		
			-- trim $ and ',' signs then change COVID_Athlete_Assistance_Fund type from text to float
			(case 
				when trim(COVID_Athlete_Assistance_Fund)like '%-' then '0'
				else trim(replace(substring(COVID_Athlete_Assistance_Fund from 2 for length(COVID_Athlete_Assistance_Fund)),',',''))
			end)::numeric as COVID_Athlete_Assistance_Fund,
		
			-- trim $ and ',' signs then change Elite_Athlete_Health_Insurance type from text to float
			(case 
			    when trim(Elite_Athlete_Health_Insurance) like '%-' then 0
			    when trim(Elite_Athlete_Health_Insurance) like '(%' 
			        then (-1) * cast(
			            replace(replace(replace(replace(Elite_Athlete_Health_Insurance, '(', ''), ')', ''), ',', ''), '$', '') AS numeric
			        )
			    else cast(
						replace(
							replace(
								substring(Elite_Athlete_Health_Insurance from 2 for length(Elite_Athlete_Health_Insurance))
							, ',', '')
						, '$', '') AS numeric
						)
			end) as Elite_Athlete_Health_Insurance,
		
			-- trim $ and ',' signs then change High_Performance_Grants type from text to float
			(case 
			    when trim(High_Performance_Grants) like '%-' then 0
			    when trim(High_Performance_Grants) like '(%' 
			        then (-1) * cast(
			            replace(replace(replace(replace(High_Performance_Grants, '(', ''), ')', ''), ',', ''), '$', '') AS numeric
			        )
			    else cast(
						replace(replace(substring(High_Performance_Grants from 2 for length(High_Performance_Grants)), ',', ''), '$', '') AS numeric
						)
			end) as High_Performance_Grants,
		
			-- trim $ and ',' signs then change High_Performance_Special_Grants type from text to float
			(case 
			    when trim(High_Performance_Special_Grants) like '%-' then 0
			    when trim(High_Performance_Special_Grants) like '(%' 
			        then (-1) * cast(
			            replace(replace(replace(replace(High_Performance_Special_Grants, '(', ''), ')', ''), ',', ''), '$', '') AS numeric
			        )
			    else cast(
						replace(replace(substring(High_Performance_Special_Grants from 2 for length(High_Performance_Special_Grants)), ',', ''), '$', '') AS numeric
						)
			end) as High_Performance_Special_Grants,
		
			-- trim $ and ',' signs then change National_Medical_Network type from text to float
			(case 
			    when trim(National_Medical_Network) like '%-' then 0
			    when trim(National_Medical_Network) like '(%' 
			        then (-1) * cast(
			            replace(replace(replace(replace(National_Medical_Network, '(', ''), ')', ''), ',', ''), '$', '') AS numeric
			        )
			    else cast(
						replace(replace(substring(National_Medical_Network from 2 for length(National_Medical_Network)), ',', ''), '$', '') AS numeric
						)
			end) as National_Medical_Network,
		
			-- trim $ and ',' signs then change NGB_HPMO_COVID_Grants type from text to float
			(case 
			    when trim(NGB_HPMO_COVID_Grants) like '%-' then 0
			    when trim(NGB_HPMO_COVID_Grants) like '(%' 
			        then (-1) * cast(
			            replace(replace(replace(replace(NGB_HPMO_COVID_Grants, '(', ''), ')', ''), ',', ''), '$', '') AS numeric
			        )
			    else cast(
						replace(replace(substring(NGB_HPMO_COVID_Grants from 2 for length(NGB_HPMO_COVID_Grants)), ',', ''), '$', '') AS numeric
						)
			end) as NGB_HPMO_COVID_Grants,
		
			-- trim $ and ',' signs then change Operation_Gold type from text to float
			(case 
			    when trim(Operation_Gold) like '%-' then 0
			    when trim(Operation_Gold) like '(%' 
			        then (-1) * cast(
			            replace(replace(replace(replace(Operation_Gold, '(', ''), ')', ''), ',', ''), '$', '') AS numeric
			        )
			    else cast(
						replace(replace(substring(Operation_Gold from 2 for length(Operation_Gold)), ',', ''), '$', '') AS numeric
						)
			end) as Operation_Gold,
		
			-- trim $ and ',' signs then change Paralympic_Sport_Development_Grants type from text to float
			(case 
			    when trim(Paralympic_Sport_Development_Grants) like '%-' then 0
			    when trim(Paralympic_Sport_Development_Grants) like '(%' 
			        then (-1) * cast(
			            replace(replace(replace(replace(Paralympic_Sport_Development_Grants, '(', ''), ')', ''), ',', ''), '$', '') AS numeric
			        )
			    else cast(
						replace(replace(substring(Paralympic_Sport_Development_Grants from 2 for length(Paralympic_Sport_Development_Grants)), ',', ''), '$', '') AS numeric
						)
			end) as Paralympic_Sport_Development_Grants,
		
			-- trim $ and ',' signs then change Restricted_Grants type from text to float
			(case 
			    when trim(Restricted_Grants) like '%-' then 0
			    when trim(Restricted_Grants) like '(%' 
			        then (-1) * cast(
			            replace(replace(replace(replace(Restricted_Grants, '(', ''), ')', ''), ',', ''), '$', '') AS numeric
			        )
			    else cast(
						replace(replace(substring(Restricted_Grants from 2 for length(Restricted_Grants)), ',', ''), '$', '') AS numeric
						)
			end) as Restricted_Grants,
		
			-- trim $ and ',' signs then change Sport_Science_Services type from text to float
			(case 
			    when trim(Sport_Science_Services) like '%-' then 0
			    when trim(Sport_Science_Services) like '(%' 
			        then (-1) * cast(
			            replace(replace(replace(replace(Sport_Science_Services, '(', ''), ')', ''), ',', ''), '$', '') AS numeric
			        )
			    else cast(
						replace(replace(substring(Sport_Science_Services from 2 for length(Sport_Science_Services)), ',', ''), '$', '') AS numeric
						)
			end) as Sport_Science_Services,
		
			-- trim $ and ',' signs then change Sports_Medicine_Clinics type from text to float
			(case 
			    when trim(Sports_Medicine_Clinics) like '%-' then 0
			    when trim(Sports_Medicine_Clinics) like '(%' 
			        then (-1) * cast(
			            replace(replace(replace(replace(Sports_Medicine_Clinics, '(', ''), ')', ''), ',', ''), '$', '') AS numeric
			        )
			    else cast(
						replace(replace(substring(Sports_Medicine_Clinics from 2 for length(Sports_Medicine_Clinics)), ',', ''), '$', '') AS numeric
						)
			end) as Sports_Medicine_Clinics,
		
			-- trim $ and ',' signs then change Facilities_Chula_Vista_California type from text to float
			(case 
			    when trim(Facilities_Chula_Vista_California) like '%-' then 0
			    when trim(Facilities_Chula_Vista_California) like '(%' 
			        then (-1) * cast(
			            replace(replace(replace(replace(Facilities_Chula_Vista_California, '(', ''), ')', ''), ',', ''), '$', '') AS numeric
			        )
			    else cast(
						replace(replace(substring(Facilities_Chula_Vista_California from 2 for length(Facilities_Chula_Vista_California)), ',', ''), '$', '') AS numeric
						)
			end) as Facilities_Chula_Vista_California,
		
			-- trim $ and ',' signs then change Facilities_Colorado_Springs_Colorado type from text to float
			(case 
			    when trim(Facilities_Colorado_Springs_Colorado) like '%-' then 0
			    when trim(Facilities_Colorado_Springs_Colorado) like '(%' 
			        then (-1) * cast(
			            replace(replace(replace(replace(Facilities_Colorado_Springs_Colorado, '(', ''), ')', ''), ',', ''), '$', '') AS numeric
			        )
			    else cast(
						replace(replace(substring(Facilities_Colorado_Springs_Colorado from 2 for length(Facilities_Colorado_Springs_Colorado)), ',', ''), '$', '') AS numeric
						)
			end) as Facilities_Colorado_Springs_Colorado,
		
			-- trim $ and ',' signs then change Facilities_Lake_Placid_New_York type from text to float
			(case 
			    when trim(Facilities_Lake_Placid_New_York) like '%-' then 0
			    when trim(Facilities_Lake_Placid_New_York) like '(%' 
			        then (-1) * cast(
			            replace(replace(replace(replace(Facilities_Lake_Placid_New_York, '(', ''), ')', ''), ',', ''), '$', '') AS numeric
			        )
			    else cast(
						replace(replace(substring(Facilities_Lake_Placid_New_York from 2 for length(Facilities_Lake_Placid_New_York)), ',', ''), '$', '') AS numeric
						)
			end) as Facilities_Lake_Placid_New_York,
		
			-- trim $ and ',' signs then change Facilities_Salt_Lake_City_Utah type from text to float
			(case 
			    when trim(Facilities_Salt_Lake_City_Utah) like '%-' then 0
			    when trim(Facilities_Salt_Lake_City_Utah) like '(%' 
			        then (-1) * cast(
			            replace(replace(replace(replace(Facilities_Salt_Lake_City_Utah, '(', ''), ')', ''), ',', ''), '$', '') AS numeric
			        )
			    else cast(
						replace(replace(substring(Facilities_Salt_Lake_City_Utah from 2 for length(Facilities_Salt_Lake_City_Utah)), ',', ''), '$', '') AS numeric
						)
			end) as Facilities_Salt_Lake_City_Utah
		from bronze.SportBenefitsStatementsDataByYear;
		end_time := clock_timestamp();
		RAISE NOTICE '>> Load duration: % seconds', extract(epoch FROM (end_time - start_time));

	EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'ERROR: Failed to load silver.SportBenefitsStatementsDataByYear : %', SQLERRM;
    END;

	RAISE NOTICE '--------------------------------';
    RAISE NOTICE 'LoadingNGBHealthDataOutputExtract table';
    RAISE NOTICE '--------------------------------';
	BEGIN
		RAISE NOTICE '>> Truncating table: silver.NGBHealthDataOutputExtract';
		TRUNCATE TABLE silver.NGBHealthDataOutputExtract RESTART IDENTITY; 
		RAISE NOTICE '>> Inserting data into silver.NGBHealthDataOutputExtract';
		start_time := clock_timestamp();
		insert into silver.NGBHealthDataOutputExtract (
			Overall_Parent_NGB,
			Overall_Year,
			Financial_Year,
			Membership_Bucket_Def,
			Revenue_Bucket_Def,
			Staff_Bucket_Def,
			CEO_Salary,
			Membership_Bucket,
			Membership_Size,
			Revenue_Bucket,
			Staff_Bucket,
			Staff_Size,
			Total_Expenses,
			Total_Revenue
		)
		select 
			case when Overall_Parent_NGB = 'US Speed Skating' then 'US Speedskating'
				when Overall_Parent_NGB = 'US Luge Association' then 'USA Luge'
				else Overall_Parent_NGB
			end as Overall_Parent_NGB,
			Overall_Year,
			coalesce (financial_year, 'n/a') as financial_year,
			coalesce (Membership_Bucket_Def, 'n/a') as Membership_Bucket_Def,
			coalesce (Revenue_Bucket_Def, 'n/a') as Revenue_Bucket_Def,
			case when Staff_Bucket_Def = '30-Oct' then '10-30'
				else Staff_Bucket_Def
			end as Staff_Bucket_Def,
			coalesce (CEO_Salary, 0) as CEO_Salary,
			coalesce (Membership_Bucket, 0) as Membership_Bucket,
			coalesce (Membership_Size, 0) as Membership_Size,
			coalesce (Revenue_Bucket, 0) as Revenue_Bucket,
			coalesce (Staff_Bucket, 0) as Staff_Bucket,
			coalesce (Staff_Size, 0) as Staff_Size,
			coalesce (Total_Expenses, 0) as Total_Expenses,
			coalesce (Total_Revenue, 0) as Total_Revenue
		from bronze.NGBHealthDataOutputExtract;

	end_time := clock_timestamp();
		RAISE NOTICE '>> Load duration: % seconds', extract(epoch FROM (end_time - start_time));
	EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'ERROR: Failed to load silver.NGBHealthDataOutputExtract  : %', SQLERRM;
    END;

	batch_end_time := clock_timestamp();
    RAISE NOTICE '================================';
    RAISE NOTICE 'Loading Silver Layer is completed';
    RAISE NOTICE '>> Total Load duration: % seconds', extract(epoch FROM (batch_end_time - batch_start_time));
    RAISE NOTICE '================================';
END; 
$$;
