-- Write your PostgreSQL query statement below
WITH s AS (
    SELECT id, visit_date, people,
    LAG(people,1) OVER(ORDER BY id) AS p1,
    LAG(people,2) OVER(ORDER BY id) AS p2,
    LEAD(people,1) OVER(ORDER BY id) AS n1,
    LEAD(people,2) OVER(ORDER BY id) AS n2,
    LAG(id,1) OVER(ORDER BY id) AS pid1,
    LAG(id,2) OVER(ORDER BY id) AS pid2,
    LEAD(id,1) OVER(ORDER BY id) AS nid1,
    LEAD(id,2) OVER(ORDER BY id) AS nid2
    FROM Stadium WHERE people >= 100
)
SELECT id, visit_date, people FROM s
WHERE (nid1 = id+1 AND nid2 = id+2 AND n1 >= 100 AND n2 >= 100)   
   OR (pid1 = id-1 AND nid1 = id+1 AND p1 >= 100 AND n1 >= 100)   
   OR (pid1 = id-1 AND pid2 = id-2 AND p1 >= 100 AND p2 >= 100)   