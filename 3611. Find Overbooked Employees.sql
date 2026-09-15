-- Write your PostgreSQL query statement below
WITH MEET AS (SELECT E.employee_id, E.employee_name, E.department,
DATE_TRUNC('week', M.meeting_date) AS week, SUM(M.duration_hours) AS tot_meeting_hrs
FROM employees E
JOIN meetings M ON E.employee_id = M.employee_id
GROUP BY E.employee_id, E.employee_name, E.department, week),

INFO AS (SELECT employee_id,employee_name, department, COUNT(*) AS meeting_heavy_weeks
FROM MEET
WHERE tot_meeting_hrs > 20
GROUP BY employee_id, employee_name, department
HAVING COUNT(*) >= 2)

SELECT employee_id,employee_name, department, meeting_heavy_weeks
FROM INFO
ORDER BY meeting_heavy_weeks DESC, employee_name