--Question 6: Payment Method Preferences by State
--Analyse payment method preferences across each state by:
--Counting the number of transactions per payment method
--Calculating the total transaction amount per payment method
--Identifying the most popular payment method (highest transaction count) in each state


WITH payment_summary AS (
    SELECT 
        c.state,
        
        CASE 
            WHEN LOWER(p.payment_method) = 'card' THEN 'Card'
            WHEN LOWER(p.payment_method) = 'cash on delivery' THEN 'Cash on Delivery'
            WHEN LOWER(p.payment_method) = 'mobile money' THEN 'Mobile Money'
            WHEN LOWER(p.payment_method) = 'bank transfer' THEN 'Bank Transfer'
            ELSE 'Other'
        END AS payment_method,
        
        COUNT(*) AS transaction_count,
        SUM(p.amount) AS total_amount

    FROM customers c
    JOIN orders o 
        ON c.customer_id = o.customer_id
    JOIN payments p 
        ON o.order_id = p.order_id

    GROUP BY 
        c.state, 
        payment_method
),

ranked_methods AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY state 
               ORDER BY transaction_count DESC
           ) AS rank
    FROM payment_summary
)

SELECT 
    state,
    payment_method,
    transaction_count,
    total_amount,
    
    CASE 
        WHEN rank = 1 THEN 'Most Popular'
        ELSE ''
    END AS popularity_status

FROM ranked_methods
ORDER BY 
    state, 
    transaction_count DESC;

