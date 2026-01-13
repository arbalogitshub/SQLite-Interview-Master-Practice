/*
Airbnb Stays Listing Earnings Insights at Checkout Question 3 
Difficulty: Medium 

Based on the top 50% of listings by earnings in July 2024, 
what percentage of these listings have ‘ocean view’ as an amenity? 
For this analysis, look at bookings that were made in July 2024
*/

-- Obtain total price for each booking per listing 
-- Filters for July 2024
WITH calculate_total_expense_per_booking AS (
  SELECT 
    l.listing_id,
    l.amenities,
    b.booking_id,
  -- CASE WHEN calculates total expense of a booking based
  -- if cleaning_fee is null then we add 0 to nightly_price * booked nights 
  -- otherwise add cleaning fee to product
    CASE 
      WHEN b.cleaning_fee IS NULL THEN (b.nightly_price * b.booked_nights)+0
      ELSE b.cleaning_fee +(b.nightly_price * b.booked_nights)
    END AS total_expense
  FROM dim_listings AS l
    JOIN fct_bookings AS b ON 
    l.listing_id = b.listing_id 
    AND strftime('%m',booking_date) = '07'
    AND strftime('%Y',booking_date) = '2024'
),

-- Use filtered data from first CTE to obtain total earnings per listing 
-- We will use total earnigs to find our top 50% 
get_quartiles AS (
  SELECT 
    listing_id,
    amenities,
    SUM(total_expense) AS total_earnings,
  -- Use Quartiles to rank our quartiles based on total_earnings per listing
  -- We will use Quartiles 3 and 4 as our top 50% of listings by earnigns
  NTILE(4) OVER (ORDER BY SUM(total_expense) ) AS Quartiles
  FROM calculate_total_expense_per_booking
  GROUP BY listing_id
)

-- In Main Query, we utilize SUM(CASE WHEN) count which listings have ocean view
-- then divide by total count of listings in our top 50% of listings by earnings
-- Made sure to filter to keep only rows where quartiles are 3 & 4
SELECT 
  ROUND(SUM(CASE WHEN amenities LIKE '%ocean view%' THEN 1 ELSE 0 END) *100.00
    /COUNT(listing_id),2) ocean_view_percent
FROM get_quartiles 
WHERE Quartiles > 2