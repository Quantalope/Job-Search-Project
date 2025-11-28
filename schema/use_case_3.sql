-- User Case 3 (Hard)

-- When a student selects a position and clicks "Apply," the system should verify that the student satisfies the GPA and major requirements, 
-- and that they have not already applied. If all conditions are met, the procedure should insert a new application record; otherwise, 
-- it returns a clear message explaining why the application cannot be submitted.
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