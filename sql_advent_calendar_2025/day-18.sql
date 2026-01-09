-- SQL Advent Calendar - Day 18
-- Title: 12 Days of Data - Progress Tracking
-- Difficulty: hard
--
-- Question:
-- Over the 12 days of her data challenge, Data Dawn tracked her daily quiz scores across different subjects. Can you find each subject's first and last recorded score to see how much she improved?
--
-- Over the 12 days of her data challenge, Data Dawn tracked her daily quiz scores across different subjects. Can you find each subject's first and last recorded score to see how much she improved?
--

-- Table Schema:
-- Table: daily_quiz_scores
--   subject: VARCHAR
--   quiz_date: DATE
--   score: INTEGER
--

-- My Solution:

WITH first_quiz_score AS (
SELECT 
  subject,
  quiz_date,
  score,
  ROW_NUMBER () OVER 
    (PARTITION BY subject ORDER BY quiz_date ASC) AS first_rn
FROM daily_quiz_scores
),

last_quiz_score AS (
SELECT 
  subject,
  quiz_date,
  score,
  ROW_NUMBER () OVER 
    (PARTITION BY subject ORDER BY quiz_date DESC) AS last_rn
FROM daily_quiz_scores
)
SELECT 
  f.subject,
  f.score,
  l.score
FROM first_quiz_score f JOIN last_quiz_score l
  ON f.subject = l.subject
WHERE f.first_rn = 1 AND l.last_rn = 1
