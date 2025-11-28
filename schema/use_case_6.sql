-- Company Use Case 3 (Hard)

-- ABC Company wants to create an application position for Biology majors. This notifies Sean, who is a Biology major looking for a co-op.

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