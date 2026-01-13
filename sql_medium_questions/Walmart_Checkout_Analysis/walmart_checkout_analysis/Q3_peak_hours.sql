-- Walmart Physical Queue Management at Checkout Question 3 
-- Difficulty: Medium 
/*
Across all stores in July 2024, which hours exhibit the longest average checkout wait times in minutes? 
This analysis will guide recommendations for optimal staffing strategies.
*/

-- This CTE obtains the average checkout time from all stores
-- for each hour of the day
WITH cte AS(
SELECT 
  -- Uses the hour of the checkout start time 
  strftime('%H',checkout_start_time) AS checkout_hour,
  
  -- Obtains average time in minutes of checkout by obtaaiing seconds of the checkout time 
  -- then divides by 60 since 60 seconds is equal to a minute
  -- then rounds to 2 decimals
   ROUND(AVG((strftime('%s', checkout_end_time) - 
     strftime('%s', checkout_start_time)) / 60),2) AS average_checkout_time_in_hour,
  
  -- We use RANK() to find our highest average checkout times 
  -- We utilized this in case we have multiple hours with the highest average checkout time
    RANK() OVER 
     (
         ORDER BY ROUND(AVG((strftime('%s', checkout_end_time) - 
                  strftime('%s', checkout_start_time)) / 60),2) 
       DESC
   ) AS  rankings
FROM fct_checkout_times
-- Filters for July 2024
WHERE strftime('%Y',checkout_start_time) ='2024'
      AND strftime('%m',checkout_start_time)='07'
GROUP BY checkout_hour

)

-- Main Query filters to keep the store hours with the highest average checkout wait time
-- in minutes 
SELECT 
  checkout_hour, 
  average_checkout_time_in_hour
FROM cte 
WHERE rankings = 1

      