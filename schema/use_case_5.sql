-- Company Use Case 2 (Medium)

-- Medium: XYZ Company wants to know the GPA (DESC order) of students applying to their open positions.

SELECT u.gpa, u.first_name, u.last_name
FROM Users u
JOIN (
    SELECT a.user_id
    FROM Positions p
    JOIN Application a ON p.position_id = a.position_id
    WHERE p.company_id = 10
) d 
ON u.user_id = d.user_id
ORDER BY u.gpa DESC;