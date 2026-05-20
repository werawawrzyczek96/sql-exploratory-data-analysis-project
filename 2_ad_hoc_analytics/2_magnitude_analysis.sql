/*
===============================================================================
2. Magnitude Analysis & Volume Drivers
===============================================================================
Script Purpose:
    This script focuses on understanding proportional contribution and scale. 
    It determines which product groups drive the business using Common Table 
    Expressions (CTEs) and window aggregations to find percentages of overall sales.
===============================================================================
*/

-- Which categories contribute the most to overall sales?
WITH category_sales AS (
    SELECT
        category,
        SUM(sales_amount) AS total_sales
    FROM gold_dta_fact_sales f
    LEFT JOIN gold_dta_dim_products p
        ON p.product_key = f.product_key
    GROUP BY category
)
SELECT
    category,
    total_sales,
    SUM(total_sales) OVER() AS overall_sales,
    -- Fixed: In MySQL, casting to FLOAT is done via SIGNED/UNSIGNED or implicit multiplication. 
    -- Kept the explicit formula but fixed formatting for clean calculation.
    CONCAT(ROUND((total_sales / SUM(total_sales) OVER()) * 100, 2), '%') AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC;
