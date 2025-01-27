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
-- 8. Find artists who lived for the longest time.
-- 9. Count the number of artists who were born and died in the same century.
-- 10. Identify artists whose nationality is `NULL` or unknown.
-- 11. How many works are in the dataset?
-- 12. What is the distribution of works across different artistic styles?
-- 13. List the top 5 styles with the highest number of works.
-- 14. Which work has the highest sale price in `product_size`?
-- 15. Find the average price of works by style.
-- 16. Identify works that are housed in multiple museums (if any).
-- 17. List works that belong to a single subject.
-- 18. Find the total number of unique subjects in the dataset.
-- 19. Identify works that are associated with the largest canvas sizes.
-- 20. Find works that are not associated with any artist (if any).
-- 21. What are the most common canvas size labels in the dataset?
-- 22. List the largest and smallest canvas sizes (by width and height).
-- 23. Find the average dimensions of all canvases in the dataset.
-- 24. Count the number of works for each canvas size label.
-- 25. Identify the canvas size with the highest average sale price.
-- 26. How many museums are included in the dataset?
-- 27. List the top 10 cities with the highest number of museums.
-- 28. Find the distribution of museums across countries.
-- 29. Identify the museum with the longest opening hours (based on `museum_hours`).
-- 30. List museums that are open every day of the week.
-- 31. Find museums that have overlapping operating hours with other museums in the same city.
-- 32. Identify the museum that houses the largest number of works.
-- 33. List museums with the highest number of unique artists.
-- 34. Count the number of museums without any works associated with them.
-- 35. Identify museums that house works of only one style.
-- 36. What is the average sale price for all works in the dataset?
-- 37. Find the top 5 most expensive works based on sale price.
-- 38. Identify works where the sale price is higher than the regular price.
-- 39. Calculate the average sale price for works grouped by canvas size.
-- 40. Identify artists whose works have the highest average sale price.
-- 41. Find the most popular subject across all works.
-- 42. Identify the average canvas size dimensions for works grouped by style.
-- 43. List the top 5 artists whose works are spread across the most museums.
-- 44. Calculate the average sale price of works grouped by museum.
-- 45. Identify the city with the highest average sale price for works displayed in its museums.
-- 46. List artists who have works displayed in museums located in multiple countries.
-- 47. Find the average lifespan of artists grouped by nationality.
-- 48. Identify museums that house works from the widest variety of styles.
-- 49. List works that belong to the most subjects (e.g., a work with multiple subjects).
-- 50. Find the correlation between canvas size (width, height) and sale price.