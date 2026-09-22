-- Write your PostgreSQL query statement below
WITH BS AS (SELECT b.book_id,b.title, b.author,b.genre, b.pages,
COUNT(*) AS no_of_ratings,
COUNT(*) FILTER (WHERE rs.session_rating <= 2) AS low_rating_count,
MIN(rs.session_rating) AS Min_rating,
COUNT(*) FILTER (WHERE rs.session_rating >= 4) AS high_rating_count,
MAX(rs.session_rating) AS Max_rating
FROM books b
JOIN reading_sessions rs ON b.book_id = rs.book_id
GROUP BY b.book_id,b.title, b.author,b.genre, b.pages
ORDER BY book_id)

SELECT book_id, title, author, genre, pages,
(Max_rating - Min_rating) AS rating_spread, ROUND((low_rating_count + high_rating_count)::NUMERIC/no_of_ratings,2) AS polarization_score
FROM BS
WHERE no_of_ratings >= 5 AND low_rating_count >= 1 AND high_rating_count >= 1
AND (low_rating_count + high_rating_count)::NUMERIC/no_of_ratings >= 0.6
ORDER BY polarization_score DESC, title DESC