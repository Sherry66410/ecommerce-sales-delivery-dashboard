USE olist_ecommerce;



/* ORDER-LEVEL EXPORT */

SELECT
    order_id,
    customer_unique_id,
    customer_state,
    category,
    order_purchase_timestamp,
    order_delivered_customer_date,
    order_estimated_delivery_date,
    revenue,
    freight,
    total_paid,
    item_count,
    review_score,
    actual_days,
    delay_days,
    on_time_flag
FROM vw_order_final;


/* SELLER-LEVEL EXPORT */

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