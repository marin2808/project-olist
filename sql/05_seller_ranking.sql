-- Question: how is the revenue distributed among sellers?
-- Scope: in_revenue = 1 
-- Grain: one row per seller


WITH seller_metric AS (
    SELECT seller_id, SUM(oi.price) as revenue, COUNT(DISTINCT o.order_id) as n_of_orders
    FROM order_items oi
    JOIN orders o
    ON o.order_id = oi.order_id 
    WHERE o.in_revenue = 1
    GROUP BY oi.seller_id),

prc_metric AS (
    SELECT seller_id, revenue, n_of_orders, SUM(revenue) OVER() as total_revenue, ROW_NUMBER() OVER(ORDER BY revenue DESC, seller_id) AS seller_rank, SUM(revenue) OVER (ORDER BY revenue DESC, seller_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_revenue
    FROM seller_metric)

SELECT seller_id, ROUND(revenue,2) AS revenue, n_of_orders, ROUND(100 * revenue / total_revenue, 2) AS prc_of_total_revenue, ROUND(100 * cumulative_revenue / total_revenue, 2) AS accumulated_prc, seller_rank
FROM prc_metric
ORDER BY seller_rank



