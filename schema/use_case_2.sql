-- User Case 2 (Medium)

-- Craig is a student majoring in Accounting, and he wants to find positions that 
-- match both his major and at least one of his technical skills (Python and Excel).

SELECT DISTINCT	p.position_id, p.title, p.location, p.required_experience, c.company_name, p.required_major
FROM Positions p
JOIN Company c
	USING (company_id)
JOIN Position_Skill ps
	USING (position_id)
JOIN User_Skill us
	USING (skill_id)
WHERE us.user_id = 11
AND p.required_major IN(
	SELECT major 
    FROM Users
    WHERE user_id = 11
    );