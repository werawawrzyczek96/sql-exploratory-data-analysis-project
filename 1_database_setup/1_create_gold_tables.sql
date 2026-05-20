/*
===============================================================================
DDL Script: Create Gold Tables
===============================================================================
Script Purpose:
    This script defines the physical table structures for the Gold Layer.
    It builds a dedicated Star Schema environment containing Dimension tables 
    for Customers and Products, and a central Fact table for Sales performance.
===============================================================================
*/

-- =============================================================================
-- 1. Dimension Table: Customers
-- =============================================================================
DROP TABLE IF EXISTS gold_dta_dim_customers;
CREATE TABLE gold_dta_dim_customers (
    customer_key INT,
    customer_id INT,
    customer_number VARCHAR(50),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    country VARCHAR(50),
    marital_status VARCHAR(50),
    gender VARCHAR(50),
    birth_date DATE,
    create_date DATE
);

-- =============================================================================
-- 2. Dimension Table: Products
-- =============================================================================
DROP TABLE IF EXISTS gold_dta_dim_products;
CREATE TABLE gold_dta_dim_products (
    product_key INT,
    product_id INT,
    product_number VARCHAR(50),
    product_name VARCHAR(50),
    category_id VARCHAR(50),
    category VARCHAR(50),
    subcategory VARCHAR(50),
    maintenance VARCHAR(50),
    cost INT,
    product_line VARCHAR(50),
    start_date DATE
);

-- =============================================================================
-- 3. Central Fact Table: Sales
-- =============================================================================
DROP TABLE IF EXISTS gold_dta_fact_sales;
CREATE TABLE gold_dta_fact_sales (
    order_number VARCHAR(50),
    product_key INT,
    customer_key INT,
    order_date DATE,
    shipping_date DATE,
    due_date DATE,
    sales_amount INT,
    quantity INT,
    price INT
);
