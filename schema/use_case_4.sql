-- Company Use Case 1 (Easy)

-- DEF Company wants to know the number of applicants to a position.

SELECT COUNT(*)
FROM Positions p 
JOIN Application a ON p.position_id = a.position_id
WHERE p.position_id = 10;