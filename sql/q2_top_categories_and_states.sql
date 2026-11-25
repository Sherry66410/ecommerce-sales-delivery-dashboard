USE olist_ecommerce;

/* Q2a: Which product categories generate the most revenue?*/

SELECT
    category,
    COUNT(DISTINCT order_id) AS num_orders,
    ROUND(SUM(revenue), 2)   AS total_revenue
FROM vw_order_final
WHERE category IS NOT NULL
GROUP BY category
ORDER BY total_revenue DESC
LIMIT 10;

/* Q2b: Which customer states generate the most revenue?*/

SELECT
    customer_state,
    COUNT(DISTINCT order_id) AS num_orders,
    ROUND(SUM(revenue), 2)   AS total_revenue
FROM vw_order_final
GROUP BY customer_state
ORDER BY total_revenue DESC;
