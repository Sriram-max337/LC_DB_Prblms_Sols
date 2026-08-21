-- Write your PostgreSQL query statement below
SELECT Users.user_id AS buyer_id,Users.join_date AS join_date, COUNT(Orders.order_id) AS orders_in_2019 FROM Users
LEFT JOIN Orders ON Users.user_id = Orders.buyer_id AND (Orders.order_date BETWEEN '2019-01-01' AND '2019-12-31')
GROUP BY Users.user_id, Users.join_date

-- Write your PostgreSQL query statement below
SELECT Users.user_id AS buyer_id,Users.join_date AS join_date, 
COUNT(CASE WHEN Orders.order_date BETWEEN '2019-01-01' AND '2019-12-31' THEN Orders.order_id END) AS orders_in_2019 FROM Users
LEFT JOIN Orders ON Users.user_id = Orders.buyer_id 
GROUP BY Users.user_id, Users.join_date