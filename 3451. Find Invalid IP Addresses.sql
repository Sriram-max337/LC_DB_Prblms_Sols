-- Write your PostgreSQL query statement below
WITH octets AS (
    SELECT ip, octet 
    FROM logs, unnest(string_to_array(ip, '.')) AS octet
),
invalid_ips AS (
    SELECT ip
    FROM octets
    GROUP BY ip
    HAVING COUNT(*) != 4
        OR SUM(CASE WHEN octet ~ '^[0-9]+$' AND octet::INT > 255 THEN 1
                     WHEN octet ~ '^0[0-9]' THEN 1 
                     ELSE 0 END) > 0
)
SELECT ip, COUNT(*) AS invalid_count
FROM logs
WHERE ip IN (SELECT ip FROM invalid_ips)
GROUP BY ip
ORDER BY invalid_count DESC, ip DESC