-- Write your PostgreSQL query statement below
WITH Cat AS (
SELECT DISTINCT P.user_id, PI.category FROM ProductPurchases P
JOIN ProductInfo PI ON P.product_id = PI.product_id
)

SELECT C1.category AS category1, C2.category AS category2,
COUNT(DISTINCT C1.user_id) AS customer_count FROM Cat C1
JOIN Cat C2 ON C1.user_id = C2.user_id AND C1.category < C2.category
GROUP BY C1.category, C2.category
HAVING COUNT(DISTINCT C1.user_id) >= 3
ORDER BY customer_count DESC, C1.category, C2.category ASC