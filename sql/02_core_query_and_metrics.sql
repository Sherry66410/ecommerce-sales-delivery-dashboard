USE olist_ecommerce;

CREATE OR REPLACE VIEW vw_order_core AS
SELECT
    o.order_id,
    o.customer_id,
    c.customer_unique_id,
    c.customer_state,
    o.order_status,
    o.order_purchase_timestamp,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,
    items.total_price          AS revenue,
    items.total_freight        AS freight,
    items.item_count,
    cat.product_category_name_english AS category,
    pay.total_paid,
    rev.review_score

FROM olist_orders o
JOIN olist_customers c
    ON c.customer_id = o.customer_id

JOIN (
    SELECT
        order_id,
        SUM(price)          AS total_price,
        SUM(freight_value)  AS total_freight,
        COUNT(*)            AS item_count
    FROM olist_order_items
    GROUP BY order_id
) items ON items.order_id = o.order_id

LEFT JOIN olist_order_items first_item
    ON first_item.order_id = o.order_id
   AND first_item.order_item_id = 1
LEFT JOIN olist_products p
    ON p.product_id = first_item.product_id
LEFT JOIN product_category_translation cat
    ON cat.product_category_name = p.product_category_name

LEFT JOIN (
    SELECT order_id, SUM(payment_value) AS total_paid
    FROM olist_order_payments
    GROUP BY order_id
) pay ON pay.order_id = o.order_id

LEFT JOIN (
    SELECT order_id, AVG(review_score) AS review_score
    FROM olist_order_reviews
    GROUP BY order_id
) rev ON rev.order_id = o.order_id

WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL;



CREATE OR REPLACE VIEW vw_order_final AS
SELECT
    v.*,
    DATEDIFF(v.order_delivered_customer_date, v.order_purchase_timestamp) AS actual_days,
    DATEDIFF(v.order_delivered_customer_date, v.order_estimated_delivery_date) AS delay_days,
    CASE
        WHEN DATEDIFF(v.order_delivered_customer_date, v.order_estimated_delivery_date) <= 0 THEN 1
        ELSE 0
    END AS on_time_flag
FROM vw_order_core v;



CREATE OR REPLACE VIEW vw_seller_scorecard AS
SELECT
    s.seller_id,
    s.seller_state,
    COUNT(DISTINCT oi.order_id)                    AS num_orders,
    ROUND(SUM(oi.price), 2)                        AS total_revenue,
    ROUND(AVG(oi.price), 2)                        AS avg_item_price,
    ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)), 1)
                                                   AS avg_delivery_days,
    ROUND(100 * COUNT(DISTINCT CASE
            WHEN DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date) <= 0
            THEN oi.order_id END)
          / COUNT(DISTINCT oi.order_id), 1)        AS on_time_pct,
    ROUND(AVG(r.review_score), 2)                  AS avg_review_score
FROM olist_order_items oi
JOIN olist_sellers s ON s.seller_id = oi.seller_id
JOIN olist_orders o  ON o.order_id = oi.order_id
   AND o.order_status = 'delivered'
   AND o.order_delivered_customer_date IS NOT NULL
LEFT JOIN (
    SELECT order_id, AVG(review_score) AS review_score
    FROM olist_order_reviews
    GROUP BY order_id
) r ON r.order_id = oi.order_id
GROUP BY s.seller_id, s.seller_state
HAVING COUNT(DISTINCT oi.order_id) >= 5;



SELECT * FROM vw_order_final LIMIT 20;

SELECT delay_days, on_time_flag, COUNT(*)
FROM vw_order_final
WHERE delay_days = 0
GROUP BY delay_days, on_time_flag;

SELECT * FROM vw_seller_scorecard ORDER BY total_revenue DESC LIMIT 20;






