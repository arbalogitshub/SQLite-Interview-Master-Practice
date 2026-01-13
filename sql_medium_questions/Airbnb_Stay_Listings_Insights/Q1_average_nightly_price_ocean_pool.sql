/*
Airbnb Stays Listing Earnings Insights at Checkout Question 1 
Difficulty: Medium 

What is the overall average nightly price for listings with either a 'pool' or 'ocean view' in July 2024? 
Consider only listings that have been booked at least once during this period.
*/

-- Obtain average nightly price, filter for July 2024 and only keep pool and ocean view amenemties 
SELECT 
  AVG(b.nightly_price)
FROM dim_listings dl
LEFT JOIN fct_bookings b ON 
dl.listing_id = b.listing_id 
AND b.booking_date BETWEEN '2024-07-01' AND '2024-07-31'
WHERE LOWER(dl.amenities) LIKE '%pool%'
  OR LOWER(dl.amenities) LIKE '%ocean view%'