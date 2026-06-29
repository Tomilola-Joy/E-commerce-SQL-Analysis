--Question 4: Quarterly Revenue Trends
--Compare quarterly revenue across 2023 and 2024.
--For each quarter: calculate total revenue, average order value, total orders.
--Identify the quarter with the highest revenue growth (2024 vs 2023).

WITH quarterly_data AS (
    SELECT 
        EXTRACT(YEAR FROM order_date) AS year,
        EXTRACT(QUARTER FROM order_date) AS quarter,
        COUNT(order_id) AS total_orders,
        SUM(total_amount) AS total_revenue,
        AVG(total_amount) AS avg_order_value
    FROM orders
    WHERE order_status = 'Delivered'
    GROUP BY year, quarter
),
growth_calc AS (
    SELECT 
        q1.quarter,
        q1.total_revenue AS revenue_2023,
        q2.total_revenue AS revenue_2024,
        q2.total_revenue - q1.total_revenue AS absolute_growth,
        ROUND(100.0 * (q2.total_revenue - q1.total_revenue) / q1.total_revenue, 2) AS growth_pct
    FROM quarterly_data q1
    JOIN quarterly_data q2 ON q1.quarter = q2.quarter AND q1.year = 2023 AND q2.year = 2024
)
SELECT 
    qd.year,
    'Q' || qd.quarter AS quarter,
    qd.total_orders,
    ROUND(qd.total_revenue, 2) AS total_revenue,
    ROUND(qd.avg_order_value, 2) AS avg_order_value,
    CASE 
        WHEN qd.year = 2024 THEN gc.growth_pct 
        ELSE NULL 
    END AS yoy_growth_pct
FROM quarterly_data qd
LEFT JOIN growth_calc gc ON qd.quarter = gc.quarter
ORDER BY qd.year, qd.quarter;
