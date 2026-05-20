/*
===============================================================================
Data Loading Script: Populate Gold Layer Tables
===============================================================================
Script Purpose:
    This script truncates the existing Gold layer tables and populates them 
    by importing clean data from flat CSV files using the high-performance 
    'LOAD DATA LOCAL INFILE' command.

Deployment Note:
    Please update the placeholder paths below ('/path/to/your/repository/...')
    to match the absolute path where the datasets are located on your machine.
===============================================================================
*/

SET SESSION sql_mode = '';

-- =============================================================================
-- 1. Loading Table: gold_dta_dim_customers
-- =============================================================================
TRUNCATE TABLE gold_dta_dim_customers; 
LOAD DATA LOCAL INFILE '/path/to/your/repository/sql-data-analytics-project/datasets/flat-files/dim_customers.csv'
INTO TABLE gold_dta_dim_customers
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

-- =============================================================================
-- 2. Loading Table: gold_dta_dim_products
-- =============================================================================
TRUNCATE TABLE gold_dta_dim_products; 
LOAD DATA LOCAL INFILE '/path/to/your/repository/sql-data-analytics-project/datasets/flat-files/dim_products.csv'
INTO TABLE gold_dta_dim_products
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

-- =============================================================================
-- 3. Loading Table: gold_dta_fact_sales
-- =============================================================================
TRUNCATE TABLE gold_dta_fact_sales; 
LOAD DATA LOCAL INFILE '/path/to/your/repository/sql-data-analytics-project/datasets/flat-files/fact_sales.csv'
INTO TABLE gold_dta_fact_sales
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;
