# Student Dropout Risk: SQL Feature Layer

SQL features for an AI-powered mentor support tool that helps mentors spot students at risk of dropping out. Built during a hackathon (team project, 3rd place).

## My role

Within the team, I wrote the SQL queries (PostgreSQL) that turn raw student activity tables into risk signals, and I evaluated the quality of the ML risk model. The 9-table database was designed by other team members.

## Features

| File | Feature | Risk signal |
|---|---|---|
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

## Evaluation Metrics

During the hackathon, we applied two main metrics: **AUC** and **Dropout Recall**.

> Note: "Dropout" here refers to student dropout (a student leaving their studies), not the regularization technique used in neural networks.

### Dropout Recall 

Recall shows what share of the students who actually dropped out the model was able to find among all real dropout cases.

```
Recall = TP / (TP + FN)
```
where:
```
AUC-ROC = integral from 0 to 1 of TPR(FPR) dFPR
```
### AUC (Area Under the ROC Curve)

In simple terms, AUC shows whether the model can correctly distinguish "at-risk" students from "not at-risk" students.

AUC is the area under the ROC curve. It evaluates the quality of a binary classifier and shows how well the model separates the positive and negative classes. Its value ranges from 0 to 1:

- **1.0:** a perfect model;
- **0.5:** the model performs no better than random guessing.

Formally, AUC is the integral of the True Positive Rate (TPR) with respect to the False Positive Rate (FPR) across all classification thresholds from 0 to 1:

```
AUC-ROC = integral from 0 to 1 of TPR(FPR) dFPR
```

The ROC curve plots TPR (y-axis) against FPR (x-axis) at varying decision thresholds.

```
TPR = TP / (TP + FN)
FPR = FP / (FP + TN)
```
where TP = True Positives, FN = False Negatives, FP = False Positives, and TN = True Negatives.

Note that TPR is the same as Recall (also known as Sensitivity).

### Source
https://educationaldatamining.org/edm2024/proceedings/2024.EDM-short-papers.32/index.html




