-- Write your PostgreSQL query statement below
WITH subs AS (
SELECT user_id, event_type, plan_name, monthly_amount,event_date, 
MAX(monthly_amount) OVER(PARTITION BY user_id) AS max_historical_amount,
COUNT(event_type) FILTER(WHERE event_type = 'downgrade') OVER(PARTITION BY user_id)AS down_count,
ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY event_date DESC, event_id DESC) AS type_rank,
MAX(event_date) OVER(PARTITION BY user_id) AS max_date,
MIN(event_date) OVER(PARTITION BY user_id) AS min_date
FROM subscription_events)

SELECT user_id, plan_name AS current_plan,monthly_amount AS current_monthly_amount, max_historical_amount,
(max_date - min_date) AS days_as_subscriber
FROM subs
WHERE type_rank = 1 AND event_type != 'cancel' AND down_count >= 1 AND monthly_amount < (max_historical_amount * 0.50) AND (max_date - min_date) >= 60
ORDER BY days_as_subscriber DESC, user_id ASC