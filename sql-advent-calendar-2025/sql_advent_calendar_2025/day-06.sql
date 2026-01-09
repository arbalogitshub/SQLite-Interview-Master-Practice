-- SQL Advent Calendar - Day 6
-- Title: Ski Resort Snowfall Rankings
-- Difficulty: hard
--
-- Question:
-- Buddy is planning a winter getaway and wants to rank ski resorts by annual snowfall. Can you help him bucket these ski resorts into quartiles?
--
-- Buddy is planning a winter getaway and wants to rank ski resorts by annual snowfall. Can you help him bucket these ski resorts into quartiles?
--

-- Table Schema:
-- Table: resort_monthly_snowfall
--   resort_id: INT
--   resort_name: VARCHAR
--   snow_month: INT
--   snowfall_inches: DECIMAL
--

-- My Solution:

WITH cte1 AS (
  SELECT
    resort_id,
    resort_name,
    SUM(snowfall_inches) AS annual_snowfall
  FROM resort_monthly_snowfall
  GROUP BY resort_id
),

cte2 AS (
  SELECT 
    resort_id,
    resort_name,
    annual_snowfall,
    ROW_NUMBER() OVER (ORDER BY annual_snowfall) AS rn,
    COUNT(*) OVER () AS total_count
FROM cte1
)
SELECT 
  resort_id,
  resort_name,
  annual_snowfall,
  CASE
        WHEN rn <= total_count * 0.25 THEN 'Q1'
        WHEN rn <= total_count * 0.50 THEN 'Q2'
        WHEN rn <= total_count * 0.75 THEN 'Q3'
        ELSE 'Q4'
    END AS quartile
FROM cte2
