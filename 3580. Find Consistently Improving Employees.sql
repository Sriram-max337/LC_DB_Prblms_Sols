-- Write your PostgreSQL query statement below
WITH E_ranks AS (
SELECT E.employee_id, E.name, PR.rating AS score, PR.review_date,
ROW_NUMBER() OVER(PARTITION BY E.employee_id ORDER BY PR.review_date DESC) AS rn
FROM employees E
JOIN performance_reviews PR ON E.employee_id = PR.employee_id
),

E_table AS (SELECT * FROM E_ranks
WHERE rn <= 3),

L_table AS (SELECT *,
LAG(score) OVER(PARTITION BY employee_id ORDER BY review_date) AS lag_score,
LEAD(score) OVER(PARTITION BY employee_id ORDER BY review_date) AS lead_score,
COUNT(*) OVER(PARTITION BY employee_id) AS rc
FROM E_table)

SELECT employee_id, name, lead_score - lag_score AS improvement_score FROM L_table
WHERE rc = 3 AND rn = 2 AND lag_score < score AND score < lead_score
ORDER BY improvement_score DESC, name ASC