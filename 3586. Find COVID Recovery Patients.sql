-- Write your PostgreSQL query statement below
WITH first_pos_date_info AS (
SELECT P.patient_id,P.patient_name, P.age, C.result,
MIN(C.test_date) AS first_pos_date
FROM patients P
INNER JOIN covid_tests C ON P.patient_id = C.patient_id
WHERE C.result = 'Positive'
GROUP BY P.patient_id, P.patient_name, P.age, C.result
),

first_neg_date_info AS (
SELECT fp.patient_id,fp.patient_name, fp.age, fp.first_pos_date,
MIN(C.test_date) AS first_neg_date
FROM first_pos_date_info fp
INNER JOIN covid_tests C ON fp.patient_id = C.patient_id
WHERE C.result = 'Negative' AND test_date > first_pos_date
GROUP BY fp.patient_id, fp.patient_name, fp.age, fp.first_pos_date, C.result
)

SELECT patient_id, patient_name, age, first_neg_date - first_pos_date AS recovery_time FROM first_neg_date_info
ORDER BY recovery_time, patient_name