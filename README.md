# Data Warehouse Analytics: Model Extension & Advanced Business Insights

## 📌 Project Overview
This project focuses on expanding an existing corporate Data Warehouse and developing a sophisticated analytical suite to drive executive business decisions. Working within a pre-existing environment, I designed and optimized a structured database pipeline — moving from initial infrastructure setup to advanced data quality scrubbing, star-schema modeling, and dynamic business intelligence reporting.

Using this newly structured layer, I built a series of advanced analytical scripts covering customer segmentation, performance velocity, cumulative trends, and ranking models to uncover insights into customer lifetime value (LTV) and product lifecycles.

---

## 🏗️ My Contributions & Data Modeling

My core responsibilities in this project focused on data infrastructure setup, data modeling, transformation, and high-level analytics:

1. **Database Setup & Schema Extension (DDL & ELT):** 
   - Initialized schemas representing operational and analytics tiers to support scalable data loading.
   - Designed and deployed clean Star Schema components (`gold_dim_customers`, `gold_dim_products`, `gold_fact_sales`) using MySQL.
   - Established data integration rules to merge conflicting operational attributes (e.g., combining distinct string fields like first and last names into consolidated master records).

2. **Data Quality Assurance:**
   - Handled database-specific anomalies, gracefully bypassing strict mode constraints to transform invalid `0000-00-00` and broken historical dates into proper, safe `NULL` values.
   - Designed robust quality checks to validate primary key uniqueness, track inconsistent column lengths, and ensure strict referential integrity by detecting orphan records across foreign references.

3. **Analytics & Segmentation Engineering:**
   - Developed complex logic to safely calculate advanced KPIs like Recency, Lifespan, Average Order Value (AOV), and Average Order Revenue (AOR) while natively shielding calculations from division-by-zero errors.
   - Implemented high-impact business tiering models to classify products by revenue performance and segment customer accounts into actionable behavioral cohorts (VIP, Regular, New).
---

## 📂 Repository Structure

```text
|-- 1_data_setup/
|   |-- create_gold_tables.sql       # DDL scripts for the new Star Schema components
|   |-- load_gold_layer.sql          # Bulk ingestion logic & master data file integration
|
|-- 2_ad_hoc_analytics/
|   |-- 1_exploration_measures.sql   # Core KPIs, descriptive statistics & base data profiling
|   |-- 2_magnitude_analysis.sql     # Volume-based metrics & high-impact revenue drivers
|   |-- 3_ranking_analysis.sql       # Top/bottom performance tracking, sales velocity & tiering
|   |-- 4_change_over_time.sql       # Temporal trends, running totals & Month-over-Month growth
|   |-- 5_data_segmentation.sql      # Value-based customer tiering & cost range classification
|
|-- 3_analytical_reporting/
    |-- 5_customer_report.sql        # Production View: Consolidated master customer lifetime value (LTV) report
    |-- 6_product_report.sql         # Production View: Consolidated product lifecycle and performance report

