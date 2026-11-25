USE olist_ecommerce;

/* Q5: How is each seller performing?  */

SELECT
    seller_id,
    seller_state,
    num_orders,
    total_revenue,
    avg_item_price,
    avg_delivery_days,
    on_time_pct,
    avg_review_score
FROM vw_seller_scorecard
ORDER BY total_revenue DESC;