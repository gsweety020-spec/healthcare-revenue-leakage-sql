/* ============================================================
   HEALTHCARE REVENUE LEAKAGE ANALYSIS
   SQL CASE STUDY
   Database: PostgreSQL
   ============================================================ */


/* ============================================================
   1. OVERALL REVENUE & COLLECTION PERFORMANCE
   ============================================================ */

SELECT
    COUNT(DISTINCT c.claim_id) AS total_claims,
    SUM(c.billed_amount) AS total_billed,
    SUM(p.paid_amount) AS total_paid,
    SUM(c.billed_amount - p.paid_amount) AS total_outstanding,
    ROUND(
        SUM(p.paid_amount) * 100.0 / SUM(c.billed_amount),
        2
    ) AS collection_rate
FROM claims c
INNER JOIN payments p
    ON c.claim_id = p.claim_id;


/* ============================================================
   2. CLAIM STATUS ANALYSIS
   ============================================================ */

SELECT
    claim_status,
    COUNT(*) AS total_claims,
    SUM(billed_amount) AS total_billed
FROM claims
GROUP BY claim_status
ORDER BY total_billed DESC;


/* ============================================================
   3. OVERALL DENIAL RATE
   ============================================================ */

SELECT
    COUNT(*) FILTER (WHERE claim_status = 'Denied') AS denied_claims,
    COUNT(*) AS total_claims,
    ROUND(
        COUNT(*) FILTER (WHERE claim_status = 'Denied')
        * 100.0 / COUNT(*),
        2
    ) AS denial_rate
FROM claims;


/* ============================================================
   4. DENIED REVENUE
   ============================================================ */

SELECT
    COUNT(*) AS denied_claims,
    SUM(billed_amount) AS denied_billed_amount
FROM claims
WHERE claim_status = 'Denied';


/* ============================================================
   5. DENIAL REASON ANALYSIS
   ============================================================ */

SELECT
    denial_reason,
    COUNT(*) AS denied_claims,
    SUM(billed_amount) AS denied_amount
FROM claims
WHERE claim_status = 'Denied'
GROUP BY denial_reason
ORDER BY denied_amount DESC;


/* ============================================================
   6. PERCENTAGE OF DENIED REVENUE BY DENIAL REASON
   ============================================================ */

WITH total_denied AS (
    SELECT
        SUM(billed_amount) AS total_denied_amount
    FROM claims
    WHERE claim_status = 'Denied'
)
SELECT
    denial_reason,
    SUM(billed_amount) AS denied_amount,
    ROUND(
        SUM(billed_amount) * 100.0 / total_denied_amount,
        2
    ) AS percentage_of_denied_revenue
FROM claims, total_denied
WHERE claim_status = 'Denied'
GROUP BY denial_reason, total_denied_amount
ORDER BY percentage_of_denied_revenue DESC;


/* ============================================================
   7. PROVIDER PERFORMANCE
   ============================================================ */

SELECT
    provider,
    COUNT(*) AS total_claims,
    SUM(billed_amount) AS total_billed,
    COUNT(*) FILTER (WHERE claim_status = 'Denied') AS denied_claims
FROM claims
GROUP BY provider
ORDER BY total_billed DESC;


/* ============================================================
   8. PROVIDER DENIAL RATE
   ============================================================ */

SELECT
    provider,
    COUNT(*) AS total_claims,
    COUNT(*) FILTER (WHERE claim_status = 'Denied') AS denied_claims,
    ROUND(
        COUNT(*) FILTER (WHERE claim_status = 'Denied')
        * 100.0 / COUNT(*),
        2
    ) AS denial_rate
FROM claims
GROUP BY provider
ORDER BY denial_rate DESC;


/* ============================================================
   9. PROVIDER DENIED REVENUE
   ============================================================ */

SELECT
    provider,
    COUNT(*) FILTER (WHERE claim_status = 'Denied') AS denied_claims,
    SUM(billed_amount) FILTER (WHERE claim_status = 'Denied') AS denied_amount
FROM claims
GROUP BY provider
ORDER BY denied_amount DESC;


/* ============================================================
   10. INSURANCE / PAYER PERFORMANCE
   ============================================================ */

SELECT
    pt.insurance,
    COUNT(*) AS total_claims,
    SUM(c.billed_amount) AS total_billed,
    COUNT(*) FILTER (WHERE c.claim_status = 'Denied') AS denied_claims,
    SUM(c.billed_amount)
        FILTER (WHERE c.claim_status = 'Denied') AS denied_amount
FROM claims c
JOIN patients pt
    ON c.patient_id = pt.patient_id
GROUP BY pt.insurance
ORDER BY denied_amount DESC;


/* ============================================================
   11. INSURANCE DENIAL RATE
   ============================================================ */

SELECT
    pt.insurance,
    COUNT(*) AS total_claims,
    COUNT(*) FILTER (WHERE c.claim_status = 'Denied') AS denied_claims,
    ROUND(
        COUNT(*) FILTER (WHERE c.claim_status = 'Denied')
        * 100.0 / COUNT(*),
        2
    ) AS denial_rate
FROM claims c
JOIN patients pt
    ON c.patient_id = pt.patient_id
GROUP BY pt.insurance
ORDER BY denial_rate DESC;


/* ============================================================
   12. PAYMENT / AR AGING ANALYSIS
   ============================================================ */

SELECT
    CASE
        WHEN days_to_payment <= 30 THEN '0-30 days'
        WHEN days_to_payment <= 60 THEN '31-60 days'
        WHEN days_to_payment <= 90 THEN '61-90 days'
        ELSE '90+ days'
    END AS payment_age,
    COUNT(*) AS total_claims,
    SUM(paid_amount) AS total_paid
FROM payments
GROUP BY payment_age
ORDER BY payment_age;


/* ============================================================
   13. AVERAGE PAYMENT TIME BY INSURANCE
   ============================================================ */

SELECT
    pt.insurance,
    COUNT(*) AS total_claims,
    ROUND(AVG(pay.days_to_payment), 2) AS avg_days_to_payment
FROM payments pay
JOIN claims c
    ON pay.claim_id = c.claim_id
JOIN patients pt
    ON c.patient_id = pt.patient_id
GROUP BY pt.insurance
ORDER BY avg_days_to_payment DESC;


/* ============================================================
   14. COLLECTION RATE BY INSURANCE
   ============================================================ */

SELECT
    pt.insurance,
    SUM(c.billed_amount) AS total_billed,
    SUM(pay.paid_amount) AS total_paid,
    ROUND(
        SUM(pay.paid_amount) * 100.0
        / SUM(c.billed_amount),
        2
    ) AS collection_rate
FROM claims c
JOIN patients pt
    ON c.patient_id = pt.patient_id
JOIN payments pay
    ON c.claim_id = pay.claim_id
GROUP BY pt.insurance
ORDER BY collection_rate DESC;