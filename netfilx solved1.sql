-- SCHEMAS of Netflix

DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
	show_id	VARCHAR(5),
	type    VARCHAR(10),
	title	VARCHAR(250),
	director VARCHAR(550),
	casts	VARCHAR(1050),
	country	VARCHAR(550),
	date_added	VARCHAR(55),
	release_year	INT,
	rating	VARCHAR(15),
	duration	VARCHAR(15),
	listed_in	VARCHAR(250),
	description VARCHAR(550)
);

SELECT * FROM netflix;

--------------------------------Netflix Problems and Solutions-------------------------------

select * from netflix_titles


--Count the Number of Movies vs TV Shows
SELECT 
    type , COUNT(*) the_total
FROM netflix_titles
GROUP BY type;




--Find All Movies/TV Shows by Director 'Robert Luketic'
select 
	* 
from netflix_titles
where director ='Robert Luketic'


--List All Movies Released in 2016
SELECT * 
FROM netflix_titles
WHERE release_year = 2016 and type ='movie';


--Find the Most Common Rating for Movies and TV Shows
select type,rating,the_total
from
(select
	type ,
	rating,
	count(*) the_total ,
	RANK() over(partition by type order by count(*) desc) the_rank
from netflix_titles
group by type,rating)t
where the_rank=1
       


--Find the Top 5 Countries with the Most Content on Netflix
select top 5
    TRIM(s.value) AS country,
    COUNT(*) AS total_content
from
    netflix_titles AS t
cross apply
    STRING_SPLIT(t.country, ',') AS s 
where
    t.country IS NOT NULL AND t.country != ''
group by
    TRIM(s.value) 
order by
    total_content desc; 



--Identify the Top 5 Longest Movies
select top(5) 
	*
from netflix_titles
where type ='movie'
order by CAST(REPLACE(duration, ' min', '') AS int) desc



--Find Content Added in the Last 5 Years
select 
	*
from netflix_titles
where date_added >= DATEADD(year,-5,getdate())


-- List All TV Shows with More Than or Equail 5 Seasons
select 
	*
from netflix_titles
where type='tv show' and duration >='5 seasions'


--Count the Number of Content Items in Each Rating
select 
	rating,
	count(*) total
from netflix_titles
group by rating
order by total desc


--Find each year and the total numbers of content release in 'United States' on netflix.
select
    YEAR(CAST(date_added AS DATE)) AS release_year,
    COUNT(show_id) AS total_content_released
from
    netflix_titles
where
    country =  'United States' AND date_added IS NOT NULL
group by
    YEAR(CAST(date_added AS DATE))
order by release_year desc



-- List All Movies that are Children & Family Movies
select
    *
from
    netflix_titles 
where type = 'Movie'AND listed_in LIKE '%Children%' AND listed_in LIKE '%Family Movies%'



--Find All Content Without a Director
select 
	* 
from netflix
where director is null ;



-- Find How Many Movies Actor 'Will Smith' Appeared in the Last 10 Years
select 
	COUNT(*) AS movies_with_will_smith
from netflix_titles
where cast like '%will smith%' and  release_year >= (YEAR(GETDATE()) - 10)


--Find the top 10 Director Make movies in 'India'
select top(10)
    director,
    COUNT(show_id) AS total_movies
from
    netflix_titles
where
    country = 'India'
    AND director IS NOT NULL 
group by
    director
order by

    total_movies desc
