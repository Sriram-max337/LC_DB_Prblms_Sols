-- Write your PostgreSQL query statement below
SELECT DISTINCT ON (user_id) user_id, time_stamp AS last_stamp FROM Logins
WHERE EXTRACT(YEAR FROM time_stamp) = 2020
ORDER BY user_id, time_stamp DESC