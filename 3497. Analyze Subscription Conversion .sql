-- Write your PostgreSQL query statement below
WITH Act_Dur AS (SELECT user_id,
ROUND(AVG(activity_duration) FILTER (WHERE activity_type = 'free_trial')::NUMERIC, 2) AS trial_avg_duration,
ROUND(AVG(activity_duration) FILTER (WHERE activity_type = 'paid')::NUMERIC, 2) AS paid_avg_duration
FROM UserActivity
GROUP BY user_id)

SELECT * FROM Act_Dur
WHERE trial_avg_duration IS NOT NULL AND paid_avg_duration IS NOT NULL
ORDER BY user_id