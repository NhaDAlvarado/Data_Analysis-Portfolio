-- Replace missing values in 'neighbourhood_group' with 'Unknown'
UPDATE public.airbnb_listings
SET neighbourhood_group = 'Unknown'
WHERE neighbourhood_group IS NULL;

-- Replace missing numerical values in 'price' with 0
UPDATE public.airbnb_listings
SET price = 0
WHERE price IS NULL;

-- Remove duplicate rows based on the id column
DELETE FROM public.airbnb_listings
WHERE id IN (
    SELECT id
    FROM (
        SELECT id, ROW_NUMBER() OVER (PARTITION BY id ORDER BY id) as row_num
        FROM public.airbnb_listings
    ) t
    WHERE t.row_num > 1
);

-- Standardize room_type to be in lowercase
UPDATE public.airbnb_listings
SET room_type = LOWER(TRIM(room_type));

-- Identify and remove rows with invalid dates
DELETE FROM public.airbnb_listings
WHERE last_review IS NOT NULL
AND last_review::text !~ '^\d{4}-\d{2}-\d{2}$';

