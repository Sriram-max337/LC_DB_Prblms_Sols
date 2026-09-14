-- Write your PostgreSQL query statement below
WITH FH AS (
SELECT D.driver_id, D.driver_name,
AVG(distance_km::NUMERIC	/fuel_consumed) AS first_half_avg
FROM drivers D
JOIN trips T On D.driver_id = T.driver_id
WHERE EXTRACT(MONTH FROM trip_date) IN (1,2,3,4,5,6)
GROUP BY D.driver_id, D.driver_name
),

SH AS (
SELECT D.driver_id, D.driver_name,
AVG(distance_km::NUMERIC/fuel_consumed) AS second_half_avg
FROM drivers D
JOIN trips T On D.driver_id = T.driver_id
WHERE EXTRACT(MONTH FROM trip_date) IN (7,8,9,10,11,12)
GROUP BY D.driver_id, D.driver_name
)

SELECT FH.driver_id, FH.driver_name, ROUND(first_half_avg, 2) AS first_half_avg,
ROUND(second_half_avg,2) AS second_half_avg,
ROUND((second_half_avg - first_half_avg),2) AS efficiency_improvement
FROM FH
JOIN SH ON FH.driver_id = SH.driver_id
WHERE ROUND(second_half_avg, 2) > ROUND(first_half_avg, 2)
ORDER BY efficiency_improvement DESC, driver_name ASC