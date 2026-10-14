-- Question: Which state has more delay to delivery the orders?
-- Scope: in_delivery_analysis = 1
-- Grain: one row per state

WITH orders_by_state AS (                                  
    SELECT c.customer_state AS states, o.days_to_delivery, o.is_delayed
    FROM orders o
    INNER JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.in_delivery_analysis = 1
),
ranked AS (                                                
    SELECT states, days_to_delivery, ROW_NUMBER() OVER (PARTITION BY states ORDER BY days_to_delivery) AS pos, COUNT(*) OVER (PARTITION BY states) AS total
    FROM orders_by_state
),
medians AS (                                               
    SELECT states, AVG(days_to_delivery) AS median_days
    FROM ranked
    WHERE pos IN ((total + 1) / 2, (total + 2) / 2)
    GROUP BY states
),
metrics AS (                                               
    SELECT states, COUNT(*) AS n_of_orders, AVG(days_to_delivery) AS average_days, AVG(is_delayed) * 100 AS pct_delayed
    FROM orders_by_state
    GROUP BY states
)
SELECT m.states, m.n_of_orders, md.median_days, ROUND(m.average_days, 1) AS average_days, ROUND(m.pct_delayed, 2) AS pct_delayed, RANK() OVER (ORDER BY md.median_days DESC, m.average_days DESC) AS slowness_rank
FROM metrics m
INNER JOIN medians md ON m.states = md.states                
ORDER BY slowness_rank;
