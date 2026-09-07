-- Write your PostgreSQL query statement below
WITH Season_Sales AS (
SELECT CASE WHEN EXTRACT(MONTH FROM sale_date) IN (12,1,2) THEN 'Winter'
			WHEN EXTRACT(MONTH FROM sale_date) IN (3,4,5) THEN 'Spring'
			WHEN EXTRACT(MONTH FROM sale_date) IN (6,7,8) THEN 'Summer'
			WHEN EXTRACT(MONTH FROM sale_date) IN (9,10,11) THEN 'Fall'
			END AS season,
category, SUM(quantity) AS total_quantity, SUM(price * quantity) AS total_revenue
FROM Sales S
JOIN products P ON S.product_id = P.product_id
GROUP BY category, season),

sale_data AS (
SELECT 
RANK() OVER(PARTITION BY season ORDER BY total_quantity DESC, total_revenue DESC, category ASC), *
FROM Season_Sales
)

SELECT season, category, total_quantity, total_revenue FROM sale_data
WHERE rank = 1
ORDER BY season