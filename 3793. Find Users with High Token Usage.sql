-- Write your PostgreSQL query statement below
WITH prompt_shit AS (
SELECT user_id,
COUNT(*) AS prompt_count,
ROUND(AVG(tokens),2) AS avg_tokens
FROM prompts
GROUP BY user_id
)

SELECT * FROM prompt_shit
WHERE prompt_count >= 3 AND user_id IN (SELECT user_id FROM prompts p2
WHERE p2.user_id = prompt_shit.user_id AND
p2.tokens > (SELECT avg_tokens FROM prompt_shit ps1 WHERE p2.user_id = ps1.user_id)
)
ORDER BY avg_tokens DESC, user_id ASC