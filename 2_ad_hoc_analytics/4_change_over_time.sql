/*
===============================================================================
4. Temporal Analysis & Performance Over Time (YoY)
===============================================================================
Script Purpose:
    This script evaluates growth trends, cumulative values (Running Totals), 
    and performance tracking over time using LEAD/LAG and window-based shifting filters.
===============================================================================
*/

-- Month-over-Month Transaction Volume Trends
SELECT
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold_dta_fact_sales
WHERE order_date IS NOT NULL
  AND order_date != '0000-00-00' 
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date);


-- Cumulative Running Total & Moving Average
-- Fixed: Outer block column name was referencing order_date, but subquery output is named order_month_date.
SELECT
    order_month_date,
    total_sales,
    SUM(total_sales) OVER(ORDER BY order_month_date) AS running_total_sales,
    AVG(avg_price) OVER (ORDER BY order_month_date) AS moving_average_price
FROM (
    SELECT
        DATE_FORMAT(order_date, '%Y-%m-%01') AS order_month_date,
        SUM(sales_amount) AS total_sales,
        AVG(price) AS avg_price
    FROM gold_dta_fact_sales
    WHERE order_date IS NOT NULL
      AND order_date != '0000-00-00' 
    GROUP BY DATE_FORMAT(order_date, '%Y-%m-%01')
) t;


-- High-Level Year over Year (YoY) Product Sales Performance Analysis
WITH yearly_product_sales AS (
    SELECT
        YEAR(f.order_date) AS order_year,
        p.product_name,
        SUM(f.sales_amount) AS current_sales
    FROM gold_dta_fact_sales f
    LEFT JOIN gold_dta_dim_products p
        ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
    GROUP BY
        YEAR(f.order_date),
        p.product_name
)
SELECT
    order_year,
    product_name,
    current_sales,
    ROUND(AVG(current_sales) OVER (PARTITION BY product_name), 0) AS avg_sales,
    current_sales - ROUND(AVG(current_sales) OVER (PARTITION BY product_name), 0) AS diff_avg,
    CASE 
        WHEN current_sales - ROUND(AVG(current_sales) OVER (PARTITION BY product_name), 0) > 0 THEN 'Above Avg'
        WHEN current_sales - ROUND(AVG(current_sales) OVER (PARTITION BY product_name), 0) < 0 THEN 'Below Avg'
        ELSE 'Avg'
    END AS avg_change,
    -- Year over Year Analytics
    LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) AS py_sales,
    current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) AS diff_py,
    CASE 
        WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
        WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
        ELSE 'No Change'
    END AS py_change
FROM yearly_product_sales
ORDER BY product_name, order_year;
