-- Write your PostgreSQL query statement below
WITH cust AS (
SELECT *, COUNT(*) OVER(PARTITION BY customer_id) AS tot_trans,
COUNT(*) FILTER (WHERE transaction_type = 'refund') OVER(PARTITION BY customer_id)::NUMERIC
/ COUNT(*) OVER(PARTITION BY customer_id) AS refund_ratio
FROM customer_transactions
) 

SELECT customer_id FROM cust
WHERE tot_trans >= 3 AND refund_ratio < 0.2
GROUP BY customer_id
HAVING MAX(transaction_date) - MIN(transaction_date) >= 30