/*
===============================================================================
5. Data Segmentation & Customer Clustering Models
===============================================================================
Script Purpose:
    This script groups business records into meaningful segments based on 
    product cost behaviors and customer engagement history (spending thresholds 
    and transaction lifespans).
===============================================================================
*/

-- =============================================================================
-- SECTION 1: Product Cost Segmentation
-- =============================================================================
WITH product_segments AS (
    SELECT
        product_key,
        product_name,
        cost,
        CASE 
            WHEN cost < 100 THEN 'Below 100'
            WHEN cost BETWEEN 100 AND 500 THEN '100-500'
            WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
            ELSE 'Above 1000'
        END AS cost_range
    FROM gold_dta_dim_products
)
SELECT
    cost_range,
    COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC;


-- =============================================================================
-- SECTION 2: Customer Behavioral Segmentation (VIP vs. Regular vs. New)
-- =============================================================================
WITH customer_spending AS (
    SELECT
        f.customer_key, 
        SUM(f.sales_amount) AS total_spending,
        MIN(order_date) AS first_order,
        MAX(order_date) AS last_order,
        PERIOD_DIFF(
            DATE_FORMAT(MAX(order_date), '%Y%m'), 
            DATE_FORMAT(MIN(order_date), '%Y%m')
        ) AS lifespan
    FROM gold_dta_fact_sales f
    LEFT JOIN gold_dta_dim_customers c
        ON f.customer_key = c.customer_key
    WHERE order_date IS NOT NULL 
      AND order_date != '0000-00-00'
    GROUP BY f.customer_key
)
SELECT
    customer_segment,
    COUNT(customer_key) AS total_customers
FROM (
    SELECT
        customer_key,
        CASE 
            WHEN lifespan > 12 AND total_spending > 5000 THEN 'VIP'
            WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
            ELSE 'New'
        END AS customer_segment
    FROM customer_spending
) t
GROUP BY customer_segment
ORDER BY total_customers DESC;
