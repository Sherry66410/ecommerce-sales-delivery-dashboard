USE olist_ecommerce;

/* Q4: Does a late delivery actually hurt the customer's review score? */

SELECT
    CASE
        WHEN delay_days <= -3 THEN '1. Early (3+ days)'
        WHEN delay_days BETWEEN -2 AND 0 THEN '2. On time'
        WHEN delay_days BETWEEN 1 AND 3 THEN '3. Slightly late (1-3 days)'
        ELSE '4. Very late (4+ days)'
    END AS delivery_bucket,
    COUNT(*)                       AS num_orders,
    ROUND(AVG(review_score), 2)    AS avg_review_score
FROM vw_order_final
WHERE review_score IS NOT NULL
GROUP BY delivery_bucket
ORDER BY delivery_bucket;
