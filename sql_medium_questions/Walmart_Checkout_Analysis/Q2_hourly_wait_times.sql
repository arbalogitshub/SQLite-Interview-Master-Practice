-- Walmart Physical Queue Management at Checkout Question 2 
-- Difficulty: Medium 
/*
For the stores with an average checkout wait time exceeding 10 minutes in July 2024, 
what are the average checkout wait times in minutes broken down by each hour of the day? 
Use the store information from dim_stores to ensure proper identification of each store. 
This detail will help pinpoint specific hours when wait times are particularly long.
*/

-- Overall Purpose of this CTE is to just get our store_ids where 
-- their average checkout wait time exceeded 10 minutes 
WITH get_store_ids AS (
SELECT 
  -- Pulls store_id only from the inner query 
  store_id
FROM (
  -- Inner Query Pulls data where the average checkout time exceed 10 mintues 
  SELECT 
     stores.store_id,
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
  -- Use Inner Join to get our store ids that are also found in fct_checkout_times
   JOIN fct_checkout_times c
    ON stores.store_id = c.store_id
    AND c.checkout_start_time BETWEEN 
   '2024-07-01' AND '2024-07-31'
  GROUP BY stores.store_id
  HAVING  AVG((strftime('%s', c.checkout_end_time) - 
     strftime('%s', c.checkout_start_time)) / 60) >10
  )
),

-- This CTE pulls the checkout time information from July 2024
test_cte AS (
 SELECT 
    store_id,
    checkout_start_time,
    checkout_end_time
 FROM fct_checkout_times
  WHERE (checkout_start_time BETWEEN  '2024-07-01' AND '2024-07-31') 
)

-- Main Query We join the two CTEs that share the same store ids in the 
-- two SELECT statements. We are implementing the hourly wait times for stores 
-- that exceeded the 10 miniute average wait time.
SELECT 
  g.store_id,  
 -- Use strftime to obtain the hour 
  strftime( '%H',t.checkout_start_time) AS checkout_hour,
  -- uses same calculation as in the first cte and the previous question to 
  -- get average time difference in minutes 
  AVG((strftime('%s', t.checkout_end_time) - 
     strftime('%s', t.checkout_start_time)) / 60) AS average_checkout_time_in_hour
FROM get_store_ids g 
  JOIN test_cte t ON 
  g.store_id = t.store_id
   -- This time since we are gettign the average checkout time in the hour,
  -- we need to group by store_id and the checkout hour 
GROUP BY g.store_id, strftime( '%H',t.checkout_start_time)

