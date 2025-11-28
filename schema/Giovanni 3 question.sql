USE HuskiesJob;

SELECT * FROM Users;
SELECT * FROM Company;
SELECT * FROM Positions;
SELECT * FROM Application;
SELECT * FROM Position_Skill;
SELECT * FROM User_Skill;

## User Case 1 (Easy)

## Jack is seeking a co-op in supply chain or business operations 
## and is open to roles anywhere in Massachusetts.

SELECT p.position_id, p.title, p.location, p.required_experience, p.work_mode, c.company_name
FROM Positions p
JOIN Company c
	USING (company_id) 
WHERE p.location LIKE "%Massachusetts%"
AND p.job_category IN ("Supply Chain", "Business Operations");

## User Case 2 (Medium)

## Michael is a junior majoring in Computer Science, and he wants to find positions that 
## match both his major and at least one of his technical skills(Python and SQL). 
## At the same time, he does not want to see jobs he has already applied for.

SELECT DISTINCT	p.position_id, p.title, p.location, p.required_experience, c.company_name
FROM Positions p
JOIN Company c
	USING (company_id)
JOIN Position_Skill ps
	USING (position_id)
JOIN User_Skill us
	USING (skill_id)
WHERE us.user_id = X #X is user id of Michael
AND p.required_major IN(
	SELECT major 
    FROM Users
    WHERE user_id = X 
    )
AND p.position_id NOT IN(
	SELECT position_id
    FROM Application
    WHERE user_id = X
    );


## User Case 1 (Hard)

## When a student selects a position and clicks “Apply,” the system should verify that the student satisfies the GPA and major requirements, 
## and that they have not already applied. If all conditions are met, the procedure should insert a new application record; otherwise, 
## it returns a clear message explaining why the application cannot be submitted.

DROP PROCEDURE IF EXISTS Apply_For_Position;
DELIMITER //

CREATE PROCEDURE Apply_For_Position
(
    IN user_id_param INT,
    IN position_id_param INT
)
BEGIN
	DECLARE gpa_var DECIMAL(3,2);
    DECLARE major_var VARCHAR(45);
	DECLARE required_major_var VARCHAR(45);
    DECLARE required_gpa_var DECIMAL(3,2);
    DECLARE message VARCHAR(255); 
    
	-- select relevant values into variables
    SELECT gpa, major
    INTO gpa_var, major_var
    FROM Users
    WHERE user_id = user_id_param;
    
	SELECT required_major, required_gpa
    INTO required_major_var, required_gpa_var
    FROM Positions
    WHERE position_id = position_id_param;
    
	-- check GPA
    IF gpa_var < required_gpa_var THEN
    SET message = CONCAT('This position requires GPA >= ', required_gpa_var);  
			SIGNAL SQLSTATE 'HY000' 
				SET MESSAGE_TEXT = message;
	END IF;
    
    -- check major
    IF major_var <> position_major_var THEN
    SET message = CONCAT('This position required major is ', required_major_var);  
			SIGNAL SQLSTATE 'HY000' 
				SET MESSAGE_TEXT = message;
	END IF;
    
	INSERT INTO Application (user_id, position_id, application_date, status)
    VALUES (user_id_param, position_id_param, CURDATE(), 'Submitted');
    
    END //
    
    DELIMITER ;
    
    
    