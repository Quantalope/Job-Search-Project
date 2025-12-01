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