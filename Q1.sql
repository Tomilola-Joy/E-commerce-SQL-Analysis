--Question 1: Customer Acquisition & 30-Day Conversion
-- This query finds the top 5 states by number of new customer sign-ups in 2024 and calculates the percentage of those customers who made at least one purchase within 30 days of signing up.

WITH customer_2024 AS (
    SELECT 
        customer_id,
        state,
        signup_date
    FROM customers
    WHERE signup_date BETWEEN '2024-01-01' AND '2024-12-31'
),

customer_conversion AS (
    SELECT 
        c.customer_id,
        c.state,
        CASE 
            WHEN EXISTS (
                SELECT 1
                FROM orders o
                WHERE o.customer_id = c.customer_id
                AND o.order_date <= c.signup_date + INTERVAL '30 days'
                AND o.order_date >= c.signup_date
            )
            THEN 1 ELSE 0
        END AS converted_30_days
    FROM customer_2024 c
)

SELECT 
    state,
    COUNT(*) AS total_signups,
    SUM(converted_30_days) AS customers_converted,
    ROUND(
        (SUM(converted_30_days)::NUMERIC / COUNT(*)) * 100,
        2
    ) AS conversion_percentage
FROM customer_conversion
GROUP BY state
ORDER BY total_signups DESC
LIMIT 5;