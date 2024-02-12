**Helping app developers come up with an idea by answering a number of questions**

**Findings**
-- 1. Paid apps have better ratings 
-- 2. Apps supporting between 10 and 30 languages have better ratings 
-- 3. Finance and Book apps have low user ratings 
-- 4. The longer the description length, the better the user rating 
-- 5. A new app should aim for an average rating above 3.5 
-- 6. Games and Entertaining apps have high user ratings, hence competition 

create table apple_description_combined as 

select * from appleStore_description1

Union all 

select * from appleStore_description2 

union all  

select * from appleStore_description3 

union all  

select * from appleStore_description4

**EDA, Exploratory Data Analysis**

-- Check the number of unique apps in both tablesAppleStore

select count(DISTINCT id) AS UniqueAppIDs
from AppleStore

select count(DISTINCT id) AS UniqueAppIDs
from apple_description_combined

-- Check for any missing values in key fields 

select count(*) AS MissingValues
from AppleStore
where track_name IS NULL or user_rating IS NULL or prime_genre is NULL

select count(*) AS MissingValues
from apple_description_combined
where app_desc IS NULL

-- Discover the number of apps per genre

SELECT prime_genre, count(*) as NumApps
from AppleStore
GROUp by 1
order by 2 desc

-- Overview of the apps' ratings 

select 
	MIN(user_rating) AS MinRating,
	MAX(user_rating) AS MaxRating,
    ROUND(AVG(user_rating), 2) AS AvgRating
FROM AppleStore

**Data Analysis** 

-- Determine if paid appshave higher user ratings than free options 

select 
	case 
    	when price > 0 then 'Paid'
        else 'Free'
    end AS AppType,
    ROUND(AVG(user_rating), 2) AS AvgRating
FROM AppleStore
group by AppType
    
-- Discover if apps with more supported languages have higher ratings 

select 
	case 
    	when lang_num < 10 then '<10 languages'
        when lang_num BETWEEN 10 and 30 then '10-30 languages'
        else '>30 languages'
    end as LanguageBucket,
    ROUND(AVG(user_rating), 2) AS AvgRating
FROm AppleStore
group by LanguageBucket
order by AvgRating desc

-- Check genres with lower user ratings 

select 
	prime_genre,
    ROUND(AVG(user_rating), 2) AS AvgRating
from AppleStore
group by prime_genre
order by AvgRating
limit 10

-- Check if there is correlation between the len of the app description and the user rating 

SELECT
	case 
    	when LENGTH(adc.app_desc) < 500 then 'Short'
        when LENGTH(adc.app_desc) between 500 and 1000 then 'Medium'
        else 'Long'
    end as DescriptionLength,
    ROUND(AVG(user_rating), 2) AS AvgRating
from AppleStore AS a 
JOIN apple_description_combined AS adc
	ON a.id = adc.id
GROUP BY DescriptionLength
order by AvgRating DESC

-- Check the top-rated apps per genre 

SELECT
	prime_genre,
    track_name,
    user_rating
FROM 
(
	select 
      prime_genre,
      track_name,
      user_rating,
      RANK() OVER(PARTITION BY prime_genre order by user_rating DESC, rating_count_tot DESC) AS Rank
	from AppleStore
) AS InnerQuery
where InnerQuery.Rank = 1












	








