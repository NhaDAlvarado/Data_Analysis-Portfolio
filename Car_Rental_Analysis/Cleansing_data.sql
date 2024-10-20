UPDATE carrentaldata
SET fueltype = 'UNKNOWN'
WHERE fueltype IS NULL;

UPDATE carrentaldata
SET location_city = 'New York'
WHERE location_city IN ('new york', 'NYC', 'ny'); 

-- remove duplicate columns
DELETE FROM carrentaldata a
USING (
    SELECT MIN(ctid) as ctid, owner_id, vehicle_make, vehicle_model, vehicle_year
    FROM public.carrentaldata
    GROUP BY owner_id, vehicle_make, vehicle_model, vehicle_year
    HAVING COUNT(*) > 1
) b
WHERE a.ctid <> b.ctid
  AND a.owner_id = b.owner_id
  AND a.vehicle_make = b.vehicle_make
  AND a.vehicle_model = b.vehicle_model
  AND a.vehicle_year = b.vehicle_year;
