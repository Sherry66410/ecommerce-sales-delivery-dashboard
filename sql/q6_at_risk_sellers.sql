USE olist_ecommerce;

/* Q6: Which sellers are top 10% by revenue but bottom 25% by rating? */

-- Q6a: summary numbers 
SELECT
    COUNT(*)                         AS at_risk_sellers,
    ROUND(SUM(total_revenue), 0)     AS at_risk_revenue,
    ROUND(100 * SUM(total_revenue) /
          (SELECT SUM(total_revenue) FROM vw_seller_scorecard_ranked), 1) AS pct_of_total_revenue,
    ROUND(AVG(avg_review_score), 2)  AS avg_rating_of_these,
    ROUND(AVG(on_time_pct), 1)       AS avg_on_time_pct
FROM vw_seller_scorecard_ranked
WHERE revenue_decile = 1 AND rating_quartile = 1;

-- Q6b: the list of those sellers
SELECT seller_id, seller_state, num_orders, total_revenue, on_time_pct, avg_review_score
FROM vw_seller_scorecard_ranked
WHERE revenue_decile = 1 AND rating_quartile = 1
ORDER BY total_revenue DESC;
