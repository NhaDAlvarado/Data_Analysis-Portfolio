-- 1. How many artists are represented in the dataset?
select count(artist_id) as num_artists
from artist;

-- 2. What is the most common nationality of the artists?
select nationality, count(artist_id) as num_artists
from artist
group by nationality
order by num_artists desc
limit 1;

-- 3. List the top 10 artists with the most works in the dataset.
select a.artist_id, a.full_name,
	count(work_id) as num_of_works
from artist as a
join works as w
on a.artist_id = w.artist_id
group by a.artist_id, a.full_name 
order by num_of_works desc
limit 10;

-- 4. How many artists belong to each artistic style?
select style, count(*) as num_of_artist
from artist
group by style; 

-- 5. Find the oldest artist in the dataset (based on `birth` year).
select full_name, birth
from artist
where birth = (
	select min(birth)
	from artist
);

-- 6. Which artists have works displayed in the most museums?
select a.artist_id, a.full_name,
	count(museum_id) as num_of_museum
from artist as a
join works as w
on a.artist_id = w.artist_id
group by a.artist_id, a.full_name 
order by num_of_museum desc
limit 1;

-- 7. List artists whose works span across multiple styles.
select artist_id, count(style) as num_of_style
from artist
group by artist_id
having count(distinct style) >1;

-- 8. Find artists who lived for the longest time.
select artist_id, full_name, (death - birth) as age
from artist 
order by age desc; 

-- 9. Count the number of artists who were born and died in the same century.
with same_century as (
	select full_name, birth, death 
	from artist 
	where floor(birth/100) = floor(death/100)
)
select count(*) as num_of_artist
from same_century;

-- 10. Identify artists whose nationality is `NULL` or unknown.
select full_name, nationality
from artist
where nationality is null or nationality = 'unknown';

-- 11. How many works are in the dataset?
select count(*) as num_of_works
from works;

-- 12. What is the distribution of works across different artistic styles?
select style, count(*) as num_of_art,
	round(100.0*count(*)/(select count(*) from works),2) as percentage
from works
group by style; 

-- 13. List the top 5 styles with the highest number of works.
select style, count(*) as num_of_art
from works
group by style
order by num_of_art desc
limit 5; 

-- 14. Which work has the highest sale price in `product_size`?
select work_id, sale_price
from product_size
order by sale_price desc
limit 1;

-- 15. Find the average price of works by style.
select style, round(avg(sale_price),2) as avg_sale_price
from product_size as p
join works as w
on p.work_id = w.work_id
group by style;

-- 16. Identify works that are housed in multiple museums (if any).
select work_id, count(distinct museum_id) as num_museums
from works
group by work_id
having count(distinct museum_id) >1;

-- 17. List works that belong to a single subject.
select work_id, count(distinct subject) as num_subjects 
from subject 
group by work_id
having count(distinct subject) =1; 

-- 18. Find the total number of unique subjects in the dataset.
select subject, count(*) as num_of_works 
from subject 
group by subject; 

/*
--Identify Non-Numeric Values
SELECT DISTINCT size_id
FROM product_size
WHERE size_id !~ '^[0-9]+$';

-- Delete Non-Numeric Values with NULL
DELETE FROM product_size
WHERE size_id !~ '^[0-9]+$';

-- alter column from varchar to int
ALTER TABLE product_size
ALTER COLUMN size_id TYPE INT
USING size_id::INTEGER;
*/

-- 19. Identify works that are associated with the largest canvas sizes.
select work_id, p.size_id, width, height
from product_size as p
left join canvas_size as c
on p.size_id = c.size_id 
where p.size_id = (
	select max(size_id) 
	from product_size);

-- 20. Find works that are not associated with any artist (if any).
select work_id
from works
where artist_id is null;

-- 21. What are the most common canvas size labels in the dataset?
select size_id, count(*) as num_of_arts
from product_size
group by size_id 
order by num_of_arts desc
limit 1;

-- 22. List the largest and smallest canvas sizes (by width and height).
select max(size_id) as max_size,
	min(size_id) as min_size
from canvas_size;

-- 23. Find the average dimensions of all canvases in the dataset.
select round(avg(width),2) as avg_width,
	round(avg(height),2) as avg_height
from canvas_size; 

-- 24. Count the number of works for each canvas size label.
select size_id, count(*) as num_of_arts
from product_size
group by size_id;

-- 25. Identify the canvas size with the highest average sale price.
select size_id, round(avg(sale_price),2) as avg_price
from product_size
group by size_id
order by avg_price desc;

-- 26. How many museums are included in the dataset?
select count(museum_id) as num_museums
from museum;

-- 27. List the top 10 cities with the highest number of museums.
select city, count(museum_id) as num_museums
from museum
group by city 
order by num_museums desc; 

-- 28. Find the distribution of museums across countries.
select country, 
	count(museum_id) as num_museums,
	round(100.0*count(museum_id)/(select count(*) from museum) ,2) as percentage
from museum
group by country;

-- 29. Identify the museum with the longest opening hours (based on `museum_hours`).
with opening_time as (
	SELECT museum_id, 
		TO_TIMESTAMP(open, 'HH24:MI')::TIME as open, 
		TO_TIMESTAMP(close, 'HH24:MI')::TIME + INTERVAL '12 hours' as close
	FROM museum_hours
)
select museum_id, open, close,
	(close-open) as opening_time
from opening_time
order by opening_time desc;

-- 30. List museums that are open every day of the week.
select museum_id, count(day) as day_open
from museum_hours 
group by museum_id 
having count(day) =7; 

-- 31. Find museums that have overlapping operating hours with other museums in the same city.
WITH hours AS (
    SELECT mh.museum_id, 
           m.city, 
           m.state, 
           mh.day,
           TO_TIMESTAMP(mh.open, 'HH:MI AM')::TIME AS open, 
           TO_TIMESTAMP(mh.close, 'HH:MI AM')::TIME AS close
    FROM museum_hours AS mh
    JOIN museum AS m
    ON mh.museum_id = m.museum_id 
),
overlapping_time as (
	SELECT h1.museum_id AS museum_1, h2.museum_id AS museum_2,
	       h1.city,
	       h1.open AS museum_1_open, h1.close AS museum_1_close,
	       h2.open AS museum_2_open, h2.close AS museum_2_close,
			row_number() over (partition by h1.museum_id order by h2.museum_id) as rn 
	FROM hours AS h1 
	JOIN hours AS h2
	ON h1.city = h2.city
	AND h1.museum_id < h2.museum_id
	AND h1.open < h2.close
	AND h1.close > h2.open
	ORDER BY h1.city
)
select museum_1, museum_2, city
from overlapping_time
where rn=1;

-- 32. Identify the museum that houses the largest number of works.
select m.museum_id, m.name,
	count(work_id) as num_of_works
from works as w
join museum as m
on w.museum_id = m.museum_id
group by m.museum_id, m.name
order by num_of_works desc;

-- 33. List museums with the highest number of unique artists.
select m.museum_id, m.name,
	count(distinct artist_id) as num_of_artists
from works as w
join museum as m
on w.museum_id = m.museum_id
group by m.museum_id, m.name
order by num_of_artists desc;

-- 34. Count the number of museums without any works associated with them.
select m.museum_id, m.name,
	count(work_id) as num_of_works
from works as w
right join museum as m
on w.museum_id = m.museum_id
group by m.museum_id, m.name
having count(work_id) =0;

-- 35. Identify museums that house works of only one style.
select m.museum_id, m.name,
	count(distinct style) as num_of_style
from works as w
right join museum as m
on w.museum_id = m.museum_id
group by m.museum_id, m.name
having count(distinct style) =1;

-- 36. What is the average sale price for all works in the dataset?
select round(avg(sale_price),2) as avg_sale_price
from product_size; 

-- 37. Find the top 5 most expensive works based on sale price.
select work_id, sale_price
from product_size
order by sale_price desc
limit 5;

-- 38. Identify works where the sale price is higher than the regular price.
select work_id, sale_price, regular_price
from product_size
where sale_price > regular_price;

-- 39. Calculate the average sale price for works grouped by canvas size.
select size_id, round(avg(sale_price),2) as avg_price
from product_size
group by size_id;

-- 40. Identify artists whose works have the highest average sale price.
select a.artist_id, a.full_name, round(avg(sale_price),2) as avg_price 
from artist as a
join works as w
on a.artist_id = w.artist_id
join product_size as p
on p.work_id = w.work_id
group by a.artist_id, a.full_name
order by avg_price desc;

-- 41. Find the most popular subject across all works.
select subject, count(work_id) as num_of_works
from subject
group by subject 
order by num_of_works desc; 

-- 42. Identify the average canvas size dimensions for works grouped by style.
select style, 
	round(avg(width),2) as avg_width, 
	round(avg(height),2) as avg_height
from works as w
join product_size as p
on w.work_id = p.work_id
join canvas_size as c
on c.size_id = p.size_id
group by style; 

-- 43. List the top 5 artists whose works are spread across the most museums.
select w.artist_id, a.full_name, 
	count(distinct museum_id) as num_of_museums
from works as w
join artist as a
on w.artist_id = a.artist_id 
group by w.artist_id, a.full_name
having count(distinct museum_id) >10; 

-- 44. Calculate the average sale price of works grouped by museum.
select w.museum_id, m.name,
	round(avg(regular_price),2) as avg_price
from works as w
join museum as m
on w.museum_id = m .museum_id 
join product_size as p
on w.work_id = p.work_id 
group by w.museum_id, m.name;

-- 45. Identify the city with the highest average sale price for works displayed in its museums.
select m.city, m.state,
	round(avg(regular_price),2) as avg_price
from works as w
join museum as m
on w.museum_id = m .museum_id 
join product_size as p
on w.work_id = p.work_id 
group by m.city, m.state
order by avg_price desc;

-- 46. List artists who have works displayed in museums located in multiple countries.
SELECT a.artist_id, 
       a.full_name, 
       COUNT(DISTINCT m.country) AS num_countries
FROM works AS w
LEFT JOIN museum AS m 
	ON w.museum_id = m.museum_id 
LEFT JOIN artist AS a 
	ON w.artist_id = a.artist_id 
GROUP BY a.artist_id, a.full_name
-- Only artists with works in multiple countries	
HAVING COUNT(DISTINCT m.country) > 1  
ORDER BY num_countries DESC;

-- 47. Find the average lifespan of artists grouped by nationality.


-- 48. Identify museums that house works from the widest variety of styles.
-- 49. List works that belong to the most subjects (e.g., a work with multiple subjects).
-- 50. Find the correlation between canvas size (width, height) and sale price.