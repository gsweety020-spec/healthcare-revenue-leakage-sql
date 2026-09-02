# Healthcare Revenue Leakage Analysis — SQL Case Study

## Project Overview

This project analyzes healthcare claims and payment data to identify revenue leakage, claim denials, payer performance, provider performance, and payment delays.

The analysis was performed using PostgreSQL and focuses on turning healthcare revenue-cycle data into actionable business insights.

## Business Problem

A healthcare organization is billing for services but collecting significantly less than the amount billed.

Management wants to understand:

- How much revenue is being collected?
- How much revenue is outstanding?
- What is driving claim denials?
- Which providers have higher denial rates?
- Which insurance payers create the greatest financial risk?
- How quickly are claims being paid?

## Dataset

The project contains three tables:

- `patients` — patient demographics and insurance information
- `claims` — claim, provider, procedure, billing, and denial information
- `payments` — payment amounts and payment timing

## Tools & Skills

- PostgreSQL
- SQL
- JOINs
- Aggregate functions
- GROUP BY
- CASE statements
- CTEs
- Conditional aggregation
- Financial analysis
- Healthcare revenue-cycle analysis

## Key Performance Indicators

| KPI | Result |
|---|---:|
| Total Claims | 300 |
| Total Billed | $109,793.27 |
| Total Paid | $49,389.71 |
| Outstanding Revenue | $60,403.56 |
| Collection Rate | 44.98% |
| Denial Rate | 22.00% |
| Denied Revenue | $28,778.52 |

## Key Findings

### 1. Revenue Collection

The organization billed $109,793.27 but collected only $49,389.71, resulting in $60,403.56 in outstanding revenue.

The overall collection rate was 44.98%.

### 2. Claim Denials

66 of 300 claims were denied, resulting in a 22% denial rate.

Denied claims represented $28,778.52 in billed revenue.

### 3. Denial Reasons

Duplicate claims generated the largest single category of denied revenue at $7,513.92.

Coding errors and missing documentation together accounted for approximately 45% of denied revenue, making them major areas for process improvement.

### 4. Provider Performance

Dr. Carter had the highest denial rate at 29.03%.

Dr. Anderson had the lowest denial rate at 11.43%.

Dr. Thompson had the highest number of denied claims at 11.

### 5. Insurance Payer Performance

Aetna had the highest denial rate at 27.50%.

UnitedHealthcare had the highest number of denied claims at 18.

Blue Cross generated the highest denied revenue at $8,401.65.

Medicare had the highest collection rate at 52.77%.

UnitedHealthcare had the lowest collection rate at 40.82%.

### 6. Payment Speed

Most claims were paid within 30 days.

185 claims were paid within 0–30 days, 80 within 31–60 days, and 35 within 61–90 days.

Medicare had the slowest average payment time at 26 days, while Aetna was fastest at 22.23 days.

## Business Recommendations

1. Reduce coding errors through targeted coding-quality reviews.
2. Strengthen documentation checks before claim submission.
3. Investigate duplicate-claim patterns to prevent avoidable denials.
4. Review Aetna and UnitedHealthcare denial patterns.
5. Investigate why some providers have substantially higher denial rates.
6. Prioritize high-dollar denial categories for revenue-recovery efforts.

## Conclusion

This analysis demonstrates how SQL can be used to transform healthcare claims and payment data into actionable revenue-cycle insights.

The analysis identifies major sources of revenue leakage and highlights opportunities to improve collections, reduce denials, and strengthen payer and provider performance.

## Project Files

- `sql/healthcare_revenue_analysis.sql`
- `data/patients.csv`
- `data/claims.csv`
- `data/payments.csv`
