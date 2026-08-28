-- Write your PostgreSQL query statement below
SELECT user_id, email FROM Users
WHERE email ~* '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9_]+[a-zA-Z]+\.com$'