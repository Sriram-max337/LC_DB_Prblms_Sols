-- Write your PostgreSQL query statement below
WITH TAB AS (
SELECT S.store_id, S.store_name,S.location,I.product_name, I.quantity, I.price,
RANK() OVER(PARTITION BY S.store_id ORDER BY I.price DESC) AS rnk_max,
RANK() OVER(PARTITION BY S.store_id ORDER BY I.price ASC) AS rnk_min,
COUNT(*) OVER(PARTITION BY S.store_id) AS prod_count
FROM stores S
JOIN inventory I ON S.store_id = I.store_id),

AGG_TAB AS (SELECT store_id, store_name,location, prod_count,
MAX(CASE WHEN rnk_max = 1 THEN product_name END) AS most_exp_product,
MAX(CASE WHEN rnk_max = 1 THEN quantity END) AS most_exp_prod_qty,
MAX(CASE WHEN rnk_min = 1 THEN product_name END) AS cheapest_product,
MAX(CASE WHEN rnk_min = 1 THEN quantity END) AS cheapest_prod_qty
FROM TAB 
GROUP BY store_id, store_name, location, prod_count)


SELECT store_id, store_name,location, most_exp_product, cheapest_product,
ROUND((cheapest_prod_qty::NUMERIC/most_exp_prod_qty),2) AS imbalance_ratio
FROM AGG_TAB
WHERE prod_count >= 3 AND cheapest_prod_qty > most_exp_prod_qty
ORDER BY imbalance_ratio DESC, store_name ASC