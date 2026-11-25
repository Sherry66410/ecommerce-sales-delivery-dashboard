USE olist_ecommerce;

/* Q1: How has revenue and order volume moved month over month? */

SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS order_month,
    COUNT(DISTINCT order_id)  AS num_orders,
    ROUND(SUM(revenue), 2)    AS total_revenue,
    ROUND(SUM(revenue) / COUNT(DISTINCT order_id), 2) AS avg_order_value
FROM vw_order_final
GROUP BY order_month
ORDER BY order_month;
