-- Write your PostgreSQL query statement below
SELECT product_id, product_name, description FROM products
WHERE description ~ '\ySN[0-9]{4}-[0-9]{4}\y'
ORDER BY product_id