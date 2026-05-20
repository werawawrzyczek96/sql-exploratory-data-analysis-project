/*
============================================================================
Customer Analytical Report
============================================================================
Purpose:
    This analytical report consolidates comprehensive customer metrics, 
    behavioral insights, and core financial performance tracking.
    
Highlights:
    1. Gathers essential customer attributes including names, explicit age groups, 
       and detailed transaction metadata.
    2. Dynamically segments customers based on relationship lifespan (VIP, Regular, New) 
       and demographic brackets.
    3. Aggregates deep customer-level measures:
        - total orders (frequency)
        - total sales revenue (monetary)
        - total quantity purchased
        - distinct product variety
        - customer lifespan (in months)
    4. Calculates critical business KPIs:
        - recency (months since last transaction)
        - average order value (AOV)
        - average monthly spend
============================================================================
*/

CREATE OR REPLACE VIEW gold_report_customers AS
WITH base_query AS (
    -- 1) Base Query: Retrieves core columns from tables
    SELECT
        f.order_number,
        f.product_key,
        f.order_date,
        f.sales_amount,
        f.quantity,
        c.customer_key,
        c.customer_number,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        TIMESTAMPDIFF(YEAR, c.birth_date, NOW()) AS age
    FROM gold_dta_fact_sales f
    LEFT JOIN gold_dta_dim_customers c
        ON c.customer_key = f.customer_key
    WHERE f.order_date IS NOT NULL
      AND f.order_date != '0000-00-00'
),
customer_aggregation AS (
    -- 2) Customer Aggregations: Summarizes key metrics at the customer level
    SELECT
        customer_key,
        customer_number,
        customer_name,
        age,
        COUNT(DISTINCT order_number) AS total_orders,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        COUNT(DISTINCT product_key) AS total_products,
        MAX(order_date) AS last_order_date,
        PERIOD_DIFF(
            DATE_FORMAT(MAX(order_date), '%Y%m'), 
            DATE_FORMAT(MIN(order_date), '%Y%m')
        ) AS lifespan
    FROM base_query
    GROUP BY
        customer_key,
        customer_number,
        customer_name,
        age
)
SELECT
    customer_key,
    customer_number,
    customer_name,
    age,
    CASE 
        WHEN age < 20 THEN 'under 20'
        WHEN age BETWEEN 20 AND 29 THEN '20-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50 and above'
    END AS age_group,
    CASE 
        WHEN lifespan > 12 AND total_sales > 5000 THEN 'VIP'
        WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
        ELSE 'New'
    END AS customer_segment,
    last_order_date, 
    TIMESTAMPDIFF(MONTH, last_order_date, NOW()) AS recency,
    total_orders,
    total_sales,
    total_quantity,
    total_products,
    lifespan,
    -- Compute average order value (AOV)
    CASE 
        WHEN total_orders = 0 THEN 0
        ELSE ROUND(total_sales / total_orders, 0)
    END AS avg_order_value,
    -- Compute average monthly spend
    CASE 
        WHEN lifespan = 0 THEN total_sales
        ELSE ROUND(total_sales / lifespan, 0)
    END AS avg_monthly_spend 
FROM customer_aggregation;
