--Question 3: Seller Fulfilment Efficiency
--Top 20 sellers by fastest average fulfilment time (min 20 orders).

WITH seller_metrics AS (
    SELECT 
        o.seller_id,
        COUNT(o.order_id) AS completed_orders,
        -- Fix: Cast the date difference to hours directly
        AVG(EXTRACT(EPOCH FROM (o.delivery_date::timestamp - o.order_date::timestamp))/3600) AS avg_fulfilment_hours,
        AVG(r.rating) AS avg_rating
    FROM orders o
    LEFT JOIN reviews r ON o.order_id = r.order_id
    WHERE 
        o.order_status = 'Delivered'
        AND o.delivery_date IS NOT NULL
        AND o.order_date IS NOT NULL
    GROUP BY o.seller_id
    HAVING COUNT(o.order_id) >= 20
)
SELECT 
    s.seller_id,
    s.seller_name,
    sm.completed_orders,
    ROUND(sm.avg_fulfilment_hours, 2) AS avg_fulfilment_hours,
    ROUND(COALESCE(sm.avg_rating, 0), 2) AS avg_customer_rating
FROM seller_metrics sm
JOIN sellers s ON sm.seller_id = s.seller_id
ORDER BY sm.avg_fulfilment_hours DESC
LIMIT 20;