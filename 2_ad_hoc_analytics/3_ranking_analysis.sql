/*
===============================================================================
3. Ranking Analysis & Performance Tiering
===============================================================================
Script Purpose:
    This script identifies top and bottom performers using analytical ranking 
    techniques (LIMIT and window functions) to isolate high and low revenue drivers.
===============================================================================
*/

-- Which 5 products generate the highest revenue?
SELECT
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold_dta_fact_sales f
LEFT JOIN gold_dta_dim_products p
    ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC
LIMIT 5;

-- Which 5 products generate the lowest revenue?
SELECT
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold_dta_fact_sales f
LEFT JOIN gold_dta_dim_products p
    ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue ASC
LIMIT 5;

-- Which 5 subcategories generate the highest revenue?
SELECT
    p.subcategory,
    SUM(f.sales_amount) AS total_revenue
FROM gold_dta_fact_sales f
LEFT JOIN gold_dta_dim_products p
    ON p.product_key = f.product_key
GROUP BY p.subcategory
ORDER BY total_revenue DESC
LIMIT 5;

-- Top 5 Products using Window Functions Subquery (Advanced approach)
SELECT * FROM (
    SELECT
        p.product_name,
        SUM(f.sales_amount) AS total_revenue,
        ROW_NUMBER() OVER (ORDER BY SUM(f.sales_amount) DESC) AS rank_products
    FROM gold_dta_fact_sales f
    LEFT JOIN gold_dta_dim_products p
        ON p.product_key = f.product_key
    GROUP BY p.product_name
) t
WHERE rank_products <= 5;

-- Find top 10 customers with highest revenue contribution
SELECT 
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold_dta_fact_sales f
LEFT JOIN gold_dta_dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_revenue DESC
LIMIT 10;
