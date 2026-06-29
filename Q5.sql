--Question 5: Customer Spend Segmentation
--Segment 2024 customers by spend (High/Medium/Low).


WITH customer_spend AS (
    SELECT 
        c.customer_id,
        COALESCE(SUM(o.total_amount), 0) AS total_spend
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id 
        AND EXTRACT(YEAR FROM o.order_date) = 2024
        AND o.order_status = 'Delivered'
    GROUP BY c.customer_id
),
segments AS (
    SELECT 
        customer_id,
        total_spend,
        CASE 
            WHEN total_spend >= 100000 THEN 'High'
            WHEN total_spend >= 50000 THEN 'Medium'
            ELSE 'Low'
        END AS spend_segment
    FROM customer_spend
)
SELECT 
    spend_segment,
    COUNT(*) AS customer_count,
    ROUND(AVG(total_spend), 2) AS avg_spend_per_customer,
    ROUND(SUM(total_spend), 2) AS total_revenue_contribution
FROM segments
GROUP BY spend_segment
ORDER BY avg_spend_per_customer DESC;