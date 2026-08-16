-- Write your PostgreSQL query statement below
SELECT request_at AS Day, ROUND(COUNT(CASE WHEN status = 'cancelled_by_driver' OR status = 'cancelled_by_client' THEN 1 END)::NUMERIC/
COUNT(*),2) AS "Cancellation Rate" FROM Trips
WHERE Trips.client_id IN (SELECT users_id FROM Users WHERE banned = 'No')
AND Trips.driver_id IN (SELECT users_id FROM Users WHERE banned = 'No') AND Trips.request_at BETWEEN '2013-10-01' AND '2013-10-03'
GROUP BY request_at