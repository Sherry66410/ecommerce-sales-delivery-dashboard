USE olist_ecommerce;

/* 
   EXTRA QUERY A: "Average order value by payment type and installment count"
   Primary payment = the payment row with the largest value per order.
 */

CREATE OR REPLACE VIEW vw_order_payment_primary AS
SELECT order_id, payment_type, payment_installments
FROM (
    SELECT
        order_id,
        payment_type,
        payment_installments,
        ROW_NUMBER() OVER (
            PARTITION BY order_id
            ORDER BY payment_value DESC, payment_sequential ASC
        ) AS rn
    FROM olist_order_payments
) ranked
WHERE rn = 1;


SELECT
    f.order_id,
    p.payment_type,
    p.payment_installments,
    f.revenue
FROM vw_order_final f
JOIN vw_order_payment_primary p ON p.order_id = f.order_id;



/* EXTRA QUERY B: "Sellers who are top 10% by revenue but bottom 25% by rating" */

CREATE OR REPLACE VIEW vw_seller_scorecard_ranked AS
SELECT
    base.*,
    NTILE(10) OVER (ORDER BY total_revenue DESC)                      AS revenue_decile,  -- 1 = top 10% revenue
    NTILE(4)  OVER (ORDER BY avg_review_score ASC, total_revenue ASC) AS rating_quartile  -- 1 = bottom 25% rating
FROM vw_seller_scorecard base;


SELECT * FROM vw_seller_scorecard_ranked;



SELECT *
FROM vw_seller_scorecard_ranked
WHERE revenue_decile = 1 AND rating_quartile = 1
ORDER BY total_revenue DESC;