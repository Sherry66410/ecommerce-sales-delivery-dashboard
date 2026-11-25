USE olist_ecommerce;

/* Q3a: What's the overall on-time delivery rate? */

SELECT
    COUNT(*)                                   AS total_orders,
    SUM(on_time_flag)                          AS on_time_orders,
    ROUND(100 * SUM(on_time_flag) / COUNT(*), 1) AS on_time_pct,
    ROUND(AVG(actual_days), 1)                 AS avg_delivery_days,
    ROUND(AVG(delay_days), 1)                  AS avg_delay_days
FROM vw_order_final;

/* Q3b: Which states have the worst on-time delivery rate?
   (Late = delay_days > 0, since delay_days is delivered - estimated) */

SELECT
    customer_state,
    COUNT(*)                                     AS total_orders,
    ROUND(100 * SUM(on_time_flag) / COUNT(*), 1)  AS on_time_pct,
    ROUND(AVG(delay_days), 1)                     AS avg_delay_days
FROM vw_order_final
GROUP BY customer_state
HAVING total_orders >= 30  
ORDER BY on_time_pct ASC;

/* Q3c: Which product categories have the worst delivery delays? */

SELECT
    category,
    COUNT(*)                    AS total_orders,
    ROUND(AVG(delay_days), 1)   AS avg_delay_days,
    ROUND(100 * SUM(on_time_flag) / COUNT(*), 1) AS on_time_pct
FROM vw_order_final
WHERE category IS NOT NULL
GROUP BY category
HAVING total_orders >= 30
ORDER BY avg_delay_days DESC
LIMIT 10;
