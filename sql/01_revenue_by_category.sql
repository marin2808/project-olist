-- Question: which category sells the most?
-- Scope: in_revenue = 1
-- Grain: one row per category
-- Answer: health and beauty


SELECT p.product_category_name_english as category, SUM(oi.price) as revenue, COUNT(DISTINCT o.order_id) as n_of_orders, COUNT(oi.order_item_id) as n_of_items, ROUND((SUM(oi.price) / SUM(SUM(oi.price)) OVER ()) * 100, 2) AS percentage_of_total
FROM order_items oi 
INNER JOIN orders o  ON oi.order_id = o.order_id
LEFT JOIN products p ON oi.product_id = p.product_id
WHERE o.in_revenue = 1
GROUP BY p.product_category_name_english
ORDER BY revenue DESC




