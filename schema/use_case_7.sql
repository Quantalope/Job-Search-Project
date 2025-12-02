/* Craig is a third-year student majoring in Accounting. 
   He has skills in Python, SQL, and Tableau. He wants to see open internship
   positions where his major matches the position’s major requirement, 
   and at least one of his skills matches the position’s required skills */

SELECT DISTINCT p.position_id, p.title, p.location, p.work_mode, p.term, p.job_type, p.required_major
FROM Users u
JOIN User_Skill us
    ON us.user_id = u.user_id
JOIN Position_Skill ps
    ON ps.skill_id = us.skill_id
JOIN Positions p
    ON p.position_id = ps.position_id
WHERE u.user_id = 2
  AND p.job_type = 'Internship'
  AND p.application_deadline >= CURDATE()
  AND p.required_major = u.major;