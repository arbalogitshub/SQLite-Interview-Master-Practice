/*
Airbnb Stays Listing Earnings Insights at Checkout Question 2 
Difficulty: Medium 

For listings with no cleaning fee (ie. NULL values in the 'cleaning_fee' column), 
what is the average difference in nightly price compared to listings with a cleaning fee in July 2024?
*/

WITH cte AS (
SELECT 
 -- Obtain average nightly price 
 ROUND(AVG(b.nightly_price),2) as avg_nightly_price,
  
-- Obtain average nightly price from bookings where cleaning_fees are not null
  (SELECT 
    ROUND(AVG(b.nightly_price),2)  as avg_nightly_price
   FROM dim_listings dl
   LEFT JOIN fct_bookings b ON 
      dl.listing_id = b.listing_id 
   AND b.booking_date BETWEEN '2024-07-01' AND '2024-07-31'
   WHERE b.cleaning_fee IS NOT  NULL) as avg_nightly_price2
  
  FROM dim_listings dl
LEFT JOIN fct_bookings b ON 
dl.listing_id = b.listing_id 
AND b.booking_date BETWEEN '2024-07-01' AND '2024-07-31'
WHERE b.cleaning_fee IS NULL
  ) 
-- Main Query gets the difference from the two averages.
SELECT avg_nightly_price - avg_nightly_price2 FROM cte