-- ========================================
-- Netflix Data Analysis Project
-- ========================================

-- Drop existing table if it exists
DROP TABLE IF EXISTS netflix;

-- Create the Netflix table
CREATE TABLE netflix (
    show_id      VARCHAR(10),
    type         VARCHAR(10),    
    title        VARCHAR(150),
    director     VARCHAR(208),    
    casts        VARCHAR(1000),    
    country      VARCHAR(150), 
    date_added   VARCHAR(50),    
    release_year INT,    
    rating       VARCHAR(10),
    duration     VARCHAR(15),    
    listed_in    VARCHAR(100),    
    description  VARCHAR(300)
);

-- View all records
SELECT * FROM netflix;

-- Count total records in the table
SELECT COUNT(*) FROM netflix;

-- ========================================
-- Exploratory Data Analysis (EDA)
-- ========================================

-- 1. Get distinct content types (Movie, TV Show)
SELECT DISTINCT type 
FROM netflix;

-- 2. Count the Number of Movies vs TV Shows
SELECT 
    type,
    COUNT(*) AS total_count
FROM netflix
GROUP BY type;

-- 3. Find the Most Common Rating for Movies and TV Shows
SELECT 
    type,
    rating
FROM (
    SELECT
        type,
        rating,
        COUNT(*) AS rating_count,
        RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
    FROM netflix
    GROUP BY type, rating
) AS ranked_ratings
WHERE ranking = 1;

-- 4. List All Movies Released in 2020
SELECT * 
FROM netflix
WHERE release_year = 2020 
  AND type = 'Movie';

-- 5. Top 5 Countries with the Most Content
SELECT 
    TRIM(UNNEST(STRING_TO_ARRAY(country, ','))) AS new_country,
    COUNT(*) AS content_count
FROM netflix
GROUP BY new_country
ORDER BY content_count DESC
LIMIT 5;

-- 6. Identify the Longest Movie (by duration in minutes)
SELECT 
    title,
    CAST(REPLACE(duration, ' min', '') AS INTEGER) AS duration_minutes
FROM netflix
WHERE type = 'Movie' 
  AND duration IS NOT NULL
ORDER BY duration_minutes DESC
LIMIT 1;

-- 7. Find Content Added in the Last 5 Years
SELECT *  
FROM netflix 
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

-- 8. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
SELECT 
    type,
    director,
    title,
    rating
FROM (
    SELECT *, TRIM(UNNEST(STRING_TO_ARRAY(director, ','))) AS new_director  
    FROM netflix
) AS directors
WHERE new_director = 'Rajiv Chilaka';

-- 9. List All TV Shows with More Than 5 Seasons
SELECT * 
FROM netflix 
WHERE type = 'TV Show'
  AND SPLIT_PART(duration, ' ', 1)::INT > 5
  AND duration LIKE '%Season%';

-- 10. Count the Number of Content Items in Each Genre
SELECT 
    TRIM(UNNEST(STRING_TO_ARRAY(listed_in, ','))) AS genre,
    COUNT(*) AS genre_count
FROM netflix
GROUP BY genre
ORDER BY genre_count DESC;

-- 11. Number of Content Items Added Each Year in India
SELECT 
    TO_CHAR(TO_DATE(date_added, 'Month DD, YYYY'), 'YYYY') AS year,
    COUNT(*) AS releases
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY year
ORDER BY year;

-- 12. List All Movies that are Documentaries
SELECT * 
FROM netflix
WHERE listed_in LIKE '%Documentaries%';

-- 13. Find All Content Without a Director
SELECT * 
FROM netflix
WHERE director IS NULL;

-- 14. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
SELECT * 
FROM netflix
WHERE casts LIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;

-- 15. Top 10 Actors with Most Appearances in Movies Produced in India
SELECT 
    TRIM(UNNEST(STRING_TO_ARRAY(casts, ','))) AS actor,
    COUNT(*) AS appearances
FROM netflix 
WHERE country ILIKE '%India%'
GROUP BY actor
ORDER BY appearances DESC
LIMIT 10;

-- 16. Categorize Content Based on 'Kill' or 'Violence' Keywords in Description
SELECT 
    CASE
        WHEN description ILIKE '%Kill%' OR description ILIKE '%Violence%' THEN 'BAD'
        ELSE 'GOOD'
    END AS category,
    COUNT(*) AS content_count
FROM netflix 
GROUP BY category;

