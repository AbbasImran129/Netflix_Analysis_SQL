--Ques1 count the number of movies and TV shows

--first method
	
	select 
	sum ( case when movie_type = 'Movie' then 1 else 0 end) as no_of_movies,
	Sum ( case when movie_type = 'TV Show' then 1 else 0 end) as no_of_series
	from netflix

--Second Method
	
	select 
	movie_type,
	count(*) as total
	from netflix 
	group by movie_type

--Ques2 List all movies released in a specific year (e.g., 2020)
	
	select title , release_year 
	from netflix
	where release_year = 2020 and movie_type = 'Movie'

--Ques3 Find the top 5 countries with the most content on Netflix
	
	select unnest(string_to_array(country, ',')) as new_country ,count(show_id)
	from netflix
	group by 1
	order by 2 desc
	limit 5

--Ques4 Identify the longest movie
	
	select * from netflix
	where movie_type = 'Movie'
		and
	      duration = (select max(duration ) from netflix)

--Ques5 Find content added in the last 5 years
	
	select * from netflix
	where date_added_clean > current_date - interval '5 years'

--Ques6 Find all the movies/TV shows by director 'Rajiv Chilaka'
	
	select * from netflix 
	where director  ilike  '%Rajiv Chilaka%'

--Ques7 List all TV shows with more than 5 seasons
	
	select title , duration from netflix
	where movie_type = 'TV Show'
	      and duration > (select split_part(duration , ' ' , 1))

--Ques8 Count the number of content items in each genre
	
	select unnest(string_to_array(listed_in, ',')) , count(show_id) from netflix 
	group by 1
	order by 2 desc

--Ques9 List all movies that are documentaries
	
	select * from netflix 
	where movie_type = 'Movie' and   listed_in = 'Documentaries' 

--Ques10 Find all content without a director

	SELECT * FROM netflix
	WHERE director IS NULL

--Ques11 Find how many movies actor 'Salman Khan' appeared in last 10 years!

	SELECT * FROM netflix
	WHERE 
	casts LIKE '%Salman Khan%'
	AND 
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10

--Ques12 Find the top 10 actors who have appeared in the highest number of movies produced in India.

	SELECT UNNEST(STRING_TO_ARRAY(casts, ',')) as actor,
	COUNT(*)
	FROM netflix
	WHERE country = 'India'
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 10

--Ques13 Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
	the description field. Label content containing these keywords as 'Bad' and all other 
	content as 'Good'. Count how many items fall into each category.
	
--Method1

	WITH cte AS (
  	SELECT *,
    	CASE
      	WHEN description ~* E'\\mkill(ing|ed|s)?\\M' THEN 'bad_movie'
      	ELSE 'good'
    	END AS category
  	FROM netflix
	)
	SELECT category, COUNT(*) AS tot_content
	FROM cte
	GROUP BY category;

--Method2
	select 
	sum(case when (description ilike '%kill%' or description ilike '%violence%') then 1 else 0 end) as BAD,
	sum(case when (description not like '%kill%' or description not like '%violence%') then 1 else 0 end) as GOOD
	from Netflix



