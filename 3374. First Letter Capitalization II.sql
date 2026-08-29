-- Write your PostgreSQL query statement below
WITH cte AS (
		SELECT content_id, content_text, UNNEST(STRING_TO_ARRAY(content_text, ' ')) string_split
		FROM user_content
	),
	cte1 AS (
		SELECT content_id, content_text, string_split, string_split2, keyid_split2, ROW_NUMBER() OVER () keyid_all_char
		FROM
			(
				SELECT content_id, content_text, string_split, keyid_split2, UNNEST(STRING_TO_ARRAY(string_split, '-')) string_split2
				FROM (
						SELECT content_id, content_text, string_split, ROW_NUMBER() OVER ( PARTITION BY content_id, content_text ) keyid_split2
						FROM cte
					)
			)
	)
	-- select * from cte2 ;
	,
    cte2 AS (
		SELECT content_id, content_text, string_split, string_split2, keyid_all_char, keyid_split2, 
		       MAX(keyid_all_char) OVER ( PARTITION BY content_id, content_text, string_split, keyid_split2 ) max_keyid_split2,
			   COUNT( CASE WHEN string_split2 = '' THEN 1 ELSE NULL END ) OVER ( PARTITION BY content_id, content_text, string_split, keyid_split2 ORDER BY NULL ) is_special,
			   COUNT(string_split2) OVER ( PARTITION BY content_id, content_text, string_split, keyid_split2 ORDER BY NULL ) count_char
		FROM cte1
	)
	-- select * from cte3;
	,
	cte3 AS (
        SELECT content_id, content_text, string_split, string_split2, keyid_all_char, keyid_split2, is_special, count_char, max_keyid_split2,
			   CASE WHEN is_special > 0 THEN UPPER(SUBSTR(string_split, 1, 1)) || LOWER(SUBSTR(string_split, 2, LENGTH(string_split)))
			   ELSE UPPER(SUBSTR(string_split2, 1, 1)) || LOWER(SUBSTR(string_split2, 2, LENGTH(string_split2))) END new_char
		FROM cte2
		ORDER BY keyid_all_char
	)
	-- select * from cte3 ;
SELECT content_id, content_text original_text,  STRING_AGG( new_char, CASE WHEN is_special = 0 AND keyid_all_char = max_keyid_split2 AND count_char = 2 AND POSITION('-' IN string_split) > 0 THEN '-' ELSE ' ' END) converted_text 
FROM
	(
		SELECT *, ROW_NUMBER() OVER ( PARTITION BY content_id, content_text, new_char ORDER BY NULL ) skip_duplicate
		FROM cte3
		ORDER BY keyid_all_char
	)
WHERE skip_duplicate :: VARCHAR LIKE CASE WHEN is_special > 0 THEN '1' ELSE '%' END
GROUP BY content_id, content_text