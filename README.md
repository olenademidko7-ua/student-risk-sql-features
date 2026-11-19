# Student Dropout Risk: SQL Feature Layer

SQL features for an AI-powered mentor support tool that helps mentors spot students at risk of dropping out. Built during a hackathon (team project, 3rd place).

## My role

Within the team, I wrote the SQL queries (PostgreSQL) that turn raw student activity tables into risk signals, and I evaluated the quality of the ML risk model. The 9-table database was designed by other team members.

## Features

| File | Feature | Risk signal |
| `01_missed_homework_count.sql` | `missed_homework_count` | Number of homework assignments past the deadline and never submitted |
| `02_late_homework_count.sql` | `late_homework_count` | Number of homework submissions after the deadline |
| `03_submission_timing_shift.sql` | `submission_timing_shift` | Change in average submission delay, first half vs second half of a student's submissions |
| `04_avg_grade.sql` | `avg_grade` | Average homework grade |
| `05_last_message_stats.sql` | `last_message_days_ago` | Days since the student's last Slack message |

## Techniques

PostgreSQL, VIEW, CTE, window functions (`ROW_NUMBER`, `COUNT OVER`), LEFT JOIN with conditions in `ON` to keep students with no activity.

## Notes

- The queries expect the tables `students`, `homework` and `slack_messages`. No student data is included in this repository.
- The model evaluation showed that ROC-AUC was unreliable on the hackathon data (only 15 students, target built from heuristic rules). Real dropout or mentor-flag labels are needed for meaningful metrics.

## How the signals fit together

Each feature answers a different question about a student, and together they cover four angles:

| Angle | Features | Question it answers |
|---|---|---|
| Discipline | `missed_homework_count`, `late_homework_count` | Is the student keeping up with deadlines? |
| Dynamics | `submission_timing_shift` | Is the student's pattern getting worse over time? |
| Quality | `avg_grade` | Is the quality of work dropping? |
| Engagement | `last_message_days_ago` | Has the student gone quiet? |

A single signal can be noise (one late homework, one quiet week). Several signals pointing the same way are what a mentor should look at first. The features are designed to be combined into a risk score that ranks students, so mentors check the most at-risk ones first.
