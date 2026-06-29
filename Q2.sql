--Question 2: Product Performance
--This query identifies the top 10 products by total revenue in 2024 including product name, category, total revenue, and total number of orders.

SELECT 
    p.product_id,
    p.product_name,
    p.category,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.line_total) AS total_revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE 
    EXTRACT(YEAR FROM o.order_date) = 2024
    AND o.order_status = 'Delivered' -- Revenue is only recognised on delivery
    AND p.unit_price IS NOT NULL    -- Exclude NULL prices
GROUP BY p.product_id, p.product_name, p.category
ORDER BY total_revenue DESC
LIMIT 10;