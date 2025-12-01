-- User Case 1 (Easy)

-- Jack is seeking a co-op in marketing or supply chain
-- and is open to roles anywhere in Massachusetts.

SELECT p.position_id, p.title, p.location, p.required_experience, p.work_mode, c.company_name
FROM Positions p
JOIN Company c
	USING (company_id) 
WHERE p.location LIKE "%MA%"
AND p.job_category IN ('Marketing', 'Supply Chain');