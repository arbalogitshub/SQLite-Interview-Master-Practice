-- SQL Advent Calendar - Day 3
-- Title: The Grinch's Best Pranks Per Target
-- Difficulty: hard
--
-- Question:
-- The Grinch has brainstormed a ton of pranks for Whoville, but he only wants to keep the top prank per target, with the highest evilness score. Return the most evil prank for each target. If two pranks have the same evilness, the more recently brainstormed wins.
--
-- The Grinch has brainstormed a ton of pranks for Whoville, but he only wants to keep the top prank per target, with the highest evilness score. Return the most evil prank for each target. If two pranks have the same evilness, the more recently brainstormed wins.
--

-- Table Schema:
-- Table: grinch_prank_ideas
--   prank_id: INTEGER
--   target_name: VARCHAR
--   prank_description: VARCHAR
--   evilness_score: INTEGER
--   created_at: TIMESTAMP
--

-- My Solution:

-- create CTE to rank the pranks by evilness and time of creation
WITH rank_the_prank AS (
  SELECT
    target_name,
    prank_description,
    created_at,
    evilness_score,
    ROW_NUMBER() 
      OVER (PARTITION BY target_name ORDER BY evilness_score DESC, created_at DESC ) AS evilest_prank_number
  FROM grinch_prank_ideas
)

  -- pull only the required data 
SELECT 
  target_name,
  prank_description
FROM rank_the_prank
WHERE evilest_prank_number = 1
