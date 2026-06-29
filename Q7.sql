--Question 7:  Review Ratings and Sales Performance
--Sales performance grouped by product rating category (High/Mid/Low).


WITH product_ratings AS (
    SELECT 
        p.product_id,
        AVG(r.rating) AS avg_rating,
        CASE 
            WHEN AVG(r.rating) >= 4.0 THEN 'High'
            WHEN AVG(r.rating) >= 3.0 THEN 'Mid'
            ELSE 'Low'
        END AS rating_category
    FROM products p
    LEFT JOIN reviews r ON p.product_id = r.product_id
    WHERE p.unit_price IS NOT NULL
    GROUP BY p.product_id
),
product_sales AS (
    SELECT 
        pr.product_id,
        pr.rating_category,
        p.unit_price,
        COALESCE(SUM(oi.line_total), 0) AS total_revenue
    FROM product_ratings pr
    JOIN products p ON pr.product_id = p.product_id
    LEFT JOIN order_items oi ON pr.product_id = oi.product_id
    LEFT JOIN orders o ON oi.order_id = o.order_id AND o.order_status = 'Delivered'
    GROUP BY pr.product_id, pr.rating_category, p.unit_price
)
SELECT 
    rating_category,
    COUNT(*) AS product_count,
    ROUND(AVG(unit_price), 2) AS avg_unit_price,
    ROUND(SUM(total_revenue), 2) AS total_revenue
FROM product_sales
GROUP BY rating_category
ORDER BY avg_unit_price DESC;