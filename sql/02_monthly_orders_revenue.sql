-- Question: How do sales evolve per month?
-- Scope: in_revenue = 1
-- Grain: one row per month

WITH monthly_metrics as (SELECT month_of_purchase, COUNT(order_id) as n_of_orders, SUM(items_value) as revenue, ROUND(AVG(items_value), 2) as average_ticket 
FROM orders 
WHERE in_revenue = 1 AND month_of_purchase >= '2017-01'
GROUP BY month_of_purchase)


SELECT month_of_purchase, n_of_orders, revenue, average_ticket, ROUND(100 * (revenue - LAG(revenue)  OVER(ORDER BY month_of_purchase))/NULLIF(LAG(revenue) OVER(ORDER BY month_of_purchase), 0),2) as revenue_variation
FROM monthly_metrics
ORDER BY month_of_purchase;

