-- Test the notification trigger

INSERT INTO Positions (company_id, title, job_category, required_major, 
             location, work_mode, salary_min, salary_max, job_type, term, description, 
             required_experience, posted_date, application_deadline, start_date)
VALUES (
    5,
    'Biology Research Assistant',
    'Research',
    'Biology',
    'MA',
    'On-site',
    20,
    25,
    'Co-op',
    'Spring 2025',
    'Some odd lowkey occulty research opportunity in molecular biology',
    'None required',
    CURDATE(),
    DATE_ADD(CURDATE(), INTERVAL 30 DAY),
    '2026-01-15'
);