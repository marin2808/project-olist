-- Question: how concentrated is the revenue among sellers?
-- Scope: in_revenue = 1
-- Grain: one row (summary of the whole marketplace)

WITH seller_revenue AS (
    SELECT oi.seller_id, SUM(oi.price) AS revenue
    FROM order_items oi
    INNER JOIN orders o ON oi.order_id = o.order_id
    WHERE o.in_revenue = 1
    GROUP BY oi.seller_id
),
ranked AS (
    SELECT seller_id, revenue, ROW_NUMBER() OVER(ORDER BY revenue DESC, seller_id) AS seller_rank, COUNT(*) OVER () AS n_sellers, SUM(revenue) OVER() AS total_revenue, SUM(revenue) OVER(ORDER BY revenue DESC, seller_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_revenue
    FROM seller_revenue
)

SELECT MAX(n_sellers) AS n_sellers,
       ROUND(MAX(total_revenue), 2) AS total_revenue,
       ROUND(100.0 * SUM(CASE WHEN seller_rank <= 10                   THEN revenue END) / MAX(total_revenue), 2) AS top_10_sellers_pct,
       ROUND(100.0 * SUM(CASE WHEN seller_rank <= 0.01 * n_sellers     THEN revenue END) / MAX(total_revenue), 2) AS top_1pct_sellers_pct,
       ROUND(100.0 * SUM(CASE WHEN seller_rank <= 0.10 * n_sellers     THEN revenue END) / MAX(total_revenue), 2) AS top_10pct_sellers_pct,
       ROUND(100.0 * SUM(CASE WHEN seller_rank <= 0.20 * n_sellers     THEN revenue END) / MAX(total_revenue), 2) AS top_20pct_sellers_pct,
       MIN(CASE WHEN cumulative_revenue >= 0.5 * total_revenue THEN seller_rank END) AS sellers_for_50pct,
       MIN(CASE WHEN cumulative_revenue >= 0.8 * total_revenue THEN seller_rank END)  AS sellers_for_80pct
FROM ranked;