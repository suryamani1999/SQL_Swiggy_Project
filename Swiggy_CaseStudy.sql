-- Checking Data and Table
select * from swiggy;

-- #Q1 how many restaurants have a rating greater than 4.5?
select count(distinct restaurant_name) as high_rated_restaurants
from swiggy
where rating>4.5;

-- #Q2 which is the top 1 city with the highest number of restaurants?
select city,count(distinct restaurant_name) 
as restaurant_count from swiggy
group by city
order by restaurant_count desc
limit 1;

-- #Q3 how many restaurants have word pizza in their name ?
select count(distinct restaurant_name) as pizza_restaurants
from swiggy 
where restaurant_name like '%Pizza%';

-- #Q4 what is the most common cuisine among the restaurants in the swiggy data
select cuisine,count(*) as cuisine_count
from swiggy
group by cuisine
order by cuisine_count desc
limit 1;

-- #Q5 what is the average rating of restaurants in each city?
select city, avg(rating) as average_rating
from swiggy group by city;

-- #Q6 what is the highest price of item under the 'recommended' menu category for each restaurant?
select distinct restaurant_name, menu_category, max(price) as highestprice
from swiggy 
where menu_category='Recommended'
group by restaurant_name,menu_category;

-- #Q7 find the top 5 most expensive restaurants that offer cuisine other than indian cuisine.
select distinct restaurant_name,cost_per_person
from swiggy 
where cuisine<>'Indian'
order by cost_per_person desc
limit 5;

-- #Q8 find the restaurants that have an average cost which is higher than the total average cost of all restaurants together
select distinct restaurant_name,cost_per_person
from swiggy 
where cost_per_person>(select avg(cost_per_person) from swiggy);

-- #Q9 retrieve the details of restaurants that have the same name but are located in different cities.
select distinct t1.restaurant_name,t1.city,t2.city
from swiggy t1 join swiggy t2 
on t1.restaurant_name=t2.restaurant_name and
t1.city<>t2.city;

-- #Q10 which restaurant offers the most number of items in the 'main course' category?
select distinct restaurant_name, menu_category, count(item) as no_of_items 
from swiggy
where menu_category='Main Course' 
group by restaurant_name,menu_category
order by no_of_items desc limit 1;

-- #Q11 list the names of restaurants that are 100% vegeatarian in alphabetical order of restaurant name.
select distinct restaurant_name,
(count(case when veg_or_nonveg='Veg' then 1 end)*100/
count(*)) as vegetarian_percetage
from swiggy
group by restaurant_name
having vegetarian_percetage=100.00
order by restaurant_name;

-- #Q12 which is the restaurant providing the lowest average price for all items?
select distinct restaurant_name, avg(price) as average_price
from swiggy 
group by restaurant_name
order by average_price 
limit 1;

-- #Q13 which top 5 restaurant offers highest number of categories?
select distinct restaurant_name, count(distinct menu_category) as no_of_categories
from swiggy
group by restaurant_name
order by no_of_categories desc 
limit 5;

-- #Q14 which restaurant provides the highest percentage of non-vegeatarian food?
select distinct restaurant_name,
(count(case when veg_or_nonveg='Non-veg' then 1 end)*100
/count(*)) as nonvegetarian_percentage
from swiggy
group by restaurant_name
order by nonvegetarian_percentage desc 
limit 1;

-- #Q15 Determine the Most Expensive and Least Expensive Cities for Dining.
WITH CityExpense AS (
    SELECT city,
        MAX(cost_per_person) AS max_cost,
        MIN(cost_per_person) AS min_cost
    FROM swiggy
    GROUP BY city
)
SELECT city,max_cost,min_cost
FROM CityExpense
ORDER BY max_cost DESC;

-- #Q16 calculate the Rating Rank for Each Restaurant Within Its City
WITH RatingRankByCity AS (
    SELECT distinct restaurant_name, city, rating,
        DENSE_RANK() OVER (PARTITION BY city ORDER BY rating DESC) AS rating_rank
    FROM swiggy
)
SELECT
    restaurant_name,
    city,
    rating,
    rating_rank
FROM RatingRankByCity
WHERE rating_rank = 1;

