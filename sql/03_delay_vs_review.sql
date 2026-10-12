-- Question: How does delay affect reviews?
-- Scope: in_review_analysis = 1 and month_of_purchase >= '2017-01'
-- Grain: one row per group

SELECT CASE WHEN is_delayed = 1 THEN 'Is delayed' ELSE 'Is not delayed' END AS delay_group, COUNT(order_id) as n_of_orders, ROUND(AVG(review_score),2) as average_review_score, ROUND(100*COUNT(order_id)*1.0/SUM(COUNT(order_id)) OVER(),2) as p_of_total, ROUND(100 * SUM(CASE WHEN review_score BETWEEN 1 AND 2 THEN 1 ELSE 0 END)*1.0/COUNT(*), 2)as pct_low_score 
FROM orders
WHERE in_review_analysis = 1 AND month_of_purchase >= '2017-01'
GROUP BY delay_group

