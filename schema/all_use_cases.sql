-- User Case 1 (Easy)

-- Jack is seeking a co-op in marketing or supply chain
-- and is open to roles anywhere in Massachusetts.

SELECT p.position_id, p.title, p.location, p.required_experience, p.work_mode, c.company_name, p.job_category
FROM Positions p
JOIN Company c
	USING (company_id) 
WHERE p.location LIKE "%MA%"
AND p.job_category IN ('Marketing', 'Supply Chain');

-- User Case 2 (Medium)

-- Craig is a student majoring in Accounting, and he wants to find positions that 
-- match both his major and at least one of his technical skills (Python, Excel, etc.).

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

-- User Case 3 (Hard)

-- When a student selects a position and clicks "Apply," the system should verify that the student satisfies the major requirements, 
-- and that they have not already applied. If all conditions are met, the procedure should insert a new application record; otherwise, 
-- it returns a clear message explaining why the application cannot be submitted.
DELIMITER //

CREATE PROCEDURE Apply_For_Position
(
    IN user_id_param INT,
    IN position_id_param INT
)
BEGIN
    DECLARE major_var VARCHAR(45);
	DECLARE required_major_var VARCHAR(45);
    DECLARE message VARCHAR(255); 
    
	-- select relevant values into variables
    SELECT major
    INTO major_var
    FROM Users
    WHERE user_id = user_id_param;
    
	SELECT required_major
    INTO required_major_var
    FROM Positions
    WHERE position_id = position_id_param;
    
    -- check major
    IF major_var <> required_major_var THEN
    SET message = CONCAT('This position required major is ', required_major_var);  
			SIGNAL SQLSTATE 'HY000' 
				SET MESSAGE_TEXT = message;
	END IF;
    
	INSERT INTO Application (user_id, position_id, application_date, status)
    VALUES (user_id_param, position_id_param, CURDATE(), 'Submitted');
    
END //
    
DELIMITER ;

-- Company Use Case 1 (Easy)

-- A company wants to know the number of applicants to a position.

SELECT COUNT(*) as num_applications
FROM Positions p 
JOIN Application a ON p.position_id = a.position_id
WHERE p.position_id = 10;

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

-- Company Use Case 3 (Hard)

-- ABC Company wants to create an application position for Biology majors. This notifies Sean, 
-- who is a Biology major looking for a co-op.

DELIMITER //

CREATE TRIGGER Notify_Matching_Majors
AFTER INSERT ON Positions
FOR EACH ROW
BEGIN
    DECLARE company_name_var VARCHAR(100);
    
    SELECT company_name INTO company_name_var
    FROM Company
    WHERE company_id = NEW.company_id;

    INSERT INTO Application (user_id, position_id, application_date, status, notes)
    SELECT
        u.user_id,
        NEW.position_id,
        CURDATE(),
        'Notified',
        CONCAT(u.first_name, '! A new position is available: ', NEW.title, ' at ', company_name_var)
    FROM Users u
    WHERE u.major = NEW.required_major;
END //

DELIMITER ;

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