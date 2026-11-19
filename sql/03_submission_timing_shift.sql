-- Feature: submission_timing_shift
-- Signal: change in the homework submission pattern over time.
-- Compares the average delay (submitted_at - deadline) in the first half
-- of a student's submissions with the second half.
-- A positive shift means the student submits later and later.
-- Note: the value is unreliable for students with only 1-2 homeworks.

CREATE VIEW student_submission_timing_shift AS
WITH ranked_homework AS (
    SELECT
        student_id,
        submitted_at,
        deadline,
        submitted_at - deadline AS delay_days,
        ROW_NUMBER() OVER (
            PARTITION BY student_id
            ORDER BY submitted_at
        ) AS rn,
        COUNT(*) OVER (
            PARTITION BY student_id
        ) AS total_cnt
    FROM homework
    WHERE submitted_at IS NOT NULL
)
SELECT
    s.id AS student_id,
    s.name,
    AVG(CASE WHEN rn <= total_cnt * 0.5 THEN delay_days END) AS early_avg_delay,
    AVG(CASE WHEN rn > total_cnt * 0.5 THEN delay_days END) AS late_avg_delay,
    (
        AVG(CASE WHEN rn > total_cnt * 0.5 THEN delay_days END)
        -
        AVG(CASE WHEN rn <= total_cnt * 0.5 THEN delay_days END)
    ) AS submission_timing_shift
FROM students s
LEFT JOIN ranked_homework h
    ON s.id = h.student_id
GROUP BY s.id, s.name;
