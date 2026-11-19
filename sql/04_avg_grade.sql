-- Feature: avg_grade
-- Signal: average homework grade per student.
-- A low or falling grade complements the discipline signals
-- (late and missed homework) with a quality signal.
-- Note: AVG ignores NULL grades, students without grades get NULL.

CREATE VIEW student_avg_grade AS
SELECT
    s.id AS student_id,
    s.name,
    AVG(h.grade) AS avg_grade
FROM students s
LEFT JOIN homework h
    ON s.id = h.student_id
GROUP BY s.id, s.name;
