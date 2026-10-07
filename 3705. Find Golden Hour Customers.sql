WITH customer_metrics AS (
    SELECT 
        customer_id, 
        COUNT(*) AS total_orders, 
        (
            COUNT(*) FILTER (
                WHERE (EXTRACT(HOUR FROM order_timestamp) >= 11 AND EXTRACT(HOUR FROM order_timestamp) < 14)
                   OR (EXTRACT(HOUR FROM order_timestamp) >= 18 AND EXTRACT(HOUR FROM order_timestamp) < 21)
            ) * 100.0 / COUNT(*)
        )::INT AS peak_hour_percentage, 
        (COUNT(order_rating) * 100.0 / COUNT(*))::INT AS orders_rated, 
        ROUND(AVG(order_rating), 2) AS average_rating 
    FROM restaurant_orders 
    GROUP BY customer_id
) 
SELECT 
    customer_id, 
    total_orders,
    peak_hour_percentage,
    average_rating 
FROM customer_metrics 
WHERE total_orders >= 3 
  AND peak_hour_percentage >= 60 
  AND orders_rated >= 50 
  AND average_rating >= 4.0
ORDER BY 
    average_rating DESC, 
    customer_id DESC;