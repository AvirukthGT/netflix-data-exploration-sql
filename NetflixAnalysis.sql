-- Netflix Project
drop table if exists netflix;
CREATE TABLE netflix
(		show_id varchar(10),
		type varchar(10),	
		title varchar(150),
		director varchar(208) ,	
		casts varchar(1000),	
		country	varchar(150), 
		date_added varchar(50),	
		release_year int,	
		rating	varchar(10),
		duration varchar(15),	
		listed_in varchar(100),	
		description varchar(300)

);


select * from netflix

select count(*) from netflix


--Distinct content TYPES

select distinct type from netflix;

--Analysis

--Count the Number of Movies vs TV Shows
select type,count(*) from netflix
group by 1

--Find the Most Common Rating for Movies and TV Shows,finding frequence of each rating type

select 
	type,rating
from(
select
	type,
	rating,
	count(*),
	RANK() over(partition by type order by count(*) desc) as ranking
from netflix
group by 1,2
) as t1 where ranking=1;

--List All Movies Released in a Specific Year (e.g., 2020)

SELECT * 
FROM netflix
WHERE release_year = 2020 and type='Movie';

-- Find the Top 5 Countries with the Most Content on Netflix

select 
	trim(UNNEST(STRING_TO_ARRAY(country,','))) as new_country ,
	count(*)
from netflix
group by 1
order by 2 desc
limit 5

--Identify the longest movie

select 
	title,
	CAST(REPLACE(duration, ' min', '') AS INTEGER) AS duration_minutes
from netflix
where type='Movie' and duration is not null
order by 2 desc
limit 1
