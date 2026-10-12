
SELECT CASE WHEN n_of_days_overdue BETWEEN 1 AND 3 THEN '1-3 days' WHEN n_of_days_overdue BETWEEN 4 AND 7 THEN '4-7 days' WHEN n_of_days_overdue BETWEEN 8 AND 14 THEN '8-14 days' WHEN n_of_days_overdue >= 15 THEN '15+ days' ELSE 'On time' END AS delay_group, COUNT(order_id) as n_of_orders, ROUND(AVG(review_score),2) as average_review_score, ROUND(100*COUNT(order_id)*1.0/SUM(COUNT(order_id)) OVER(),2) as p_of_total, ROUND(100* SUM(CASE WHEN review_score BETWEEN 1 AND 2 THEN 1 ELSE 0 END)*1.0/COUNT(*), 2)as pct_low_score 
FROM orders
WHERE in_review_analysis = 1 AND month_of_purchase >= '2017-01'
GROUP BY delay_group
ORDER BY (n_of_days_overdue)