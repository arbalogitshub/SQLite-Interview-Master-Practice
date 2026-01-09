-- SQL Advent Calendar - Day 12
-- Title: North Pole Network Most Active Users
-- Difficulty: hard
--
-- Question:
-- The North Pole Network wants to see who's the most active in the holiday chat each day. Write a query to count how many messages each user sent, then find the most active user(s) each day. If multiple users tie for first place, return all of them.
--
-- The North Pole Network wants to see who's the most active in the holiday chat each day. Write a query to count how many messages each user sent, then find the most active user(s) each day. If multiple users tie for first place, return all of them.
--

-- Table Schema:
-- Table: npn_users
--   user_id: INT
--   user_name: VARCHAR
--
-- Table: npn_messages
--   message_id: INT
--   sender_id: INT
--   sent_at: TIMESTAMP
--

-- My Solution:

-- Get count of messages sent by each day 
WITH cte AS (
SELECT 
  u.user_name, 
  date(m.sent_at) AS sent_date,
  COUNT (m.message_id) as messages_sent,
  RANK() OVER (
    PARTITION BY date(m.sent_at)
    ORDER BY COUNT (m.message_id) DESC 
  ) ranks
FROM npn_users u
  LEFT JOIN  npn_messages m 
  ON u.user_id = m.sender_id
GROUP BY u.user_id,  date(m.sent_at)
ORDER BY date(m.sent_at)
) 

SELECT sent_date, user_name, messages_sent
FROM cte 
WHERE ranks = 1 
ORDER BY sent_date
