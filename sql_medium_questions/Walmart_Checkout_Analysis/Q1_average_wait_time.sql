-- Walmart Physical Queue Management at Checkout Question 1 
-- Difficulty: Medium 
/*
What is the average checkout wait time in minutes for each Walmart store during July 2024? 
Include the store name from the dim_stores table to identify location-specific impacts. 
This metric will help determine which stores have longer customer wait times.
*/


SELECT 
   stores.store_name,
   stores.location,
  /* 
   Obtain checkout minute difference by getting the difference between 
   checkout_end_time and checkout_start_time in seconds then divide by 60
   since 60 seconds is 1 minute. Then we use AVG() to get our average wait time
  */
   AVG((strftime('%s', c.checkout_end_time) - 
     strftime('%s', c.checkout_start_time)) / 60) AS minute_difference
FROM 
   dim_stores stores 
 JOIN fct_checkout_times c
  ON stores.store_id = c.store_id
  AND c.checkout_start_time BETWEEN 
   '2024-07-01' AND '2024-07-31'
GROUP BY stores.store_id