-- Feature: late_homework_count
-- Signal: number of homework submissions after the deadline.
-- Higher values can indicate that a student is losing pace.
-- Note: LEFT JOIN keeps students with no late homework (count = 0).

CREATE VIEW student_late_homework_count AS
SELECT
    s.id AS student_id,
    s.name,
    COUNT(h.id) AS late_homework_count
FROM students s
LEFT JOIN homework h
    ON s.id = h.student_id
   AND h.submitted_at IS NOT NULL
   AND h.submitted_at > h.deadline
GROUP BY s.id, s.name;
