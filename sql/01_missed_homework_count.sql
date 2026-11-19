-- Feature: missed_homework_count
-- Signal: number of homework assignments whose deadline has passed
-- and that were never submitted.
-- Note: re-created after the hackathon from the feature description.
-- It was not tested against the original data (no database access).
-- Assumes one row per assigned homework per student, with
-- submitted_at = NULL when the student did not submit.

CREATE VIEW student_missed_homework_count AS
SELECT
    s.id AS student_id,
    s.name,
    COUNT(h.id) AS missed_homework_count
FROM students s
LEFT JOIN homework h
    ON s.id = h.student_id
   AND h.submitted_at IS NULL
   AND h.deadline < NOW()
GROUP BY s.id, s.name;
