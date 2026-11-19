-- Feature: last_message_days_ago
-- Signal: days since the student's last Slack message.
-- A growing gap can indicate that a student is disengaging.
-- Note: the is_from_student filter is in the ON clause, so students
-- who never wrote (last_message_date = NULL) stay in the result.

CREATE VIEW student_last_message_stats AS
SELECT
    s.id AS student_id,
    s.name,
    MAX(sm.sent_at) AS last_message_date,
    CURRENT_DATE - MAX(sm.sent_at)::date AS last_message_days_ago
FROM students s
LEFT JOIN slack_messages sm
    ON s.id = sm.student_id
   AND sm.is_from_student = TRUE
GROUP BY s.id, s.name;
