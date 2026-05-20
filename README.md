# Data Warehouse Analytics: Model Extension & Advanced Business Insights

## 📌 Project Overview
This project focuses on expanding an existing corporate Data Warehouse and developing a sophisticated analytical suite to drive executive business decisions. Working within a pre-existing environment, I designed new data structures (Dimension and Fact views) in the **Gold Layer** to establish a clean Star Schema. 

Using this newly structured layer, I built a series of advanced analytical scripts covering customer segmentation, performance velocity, cumulative trends, and ranking models to uncover insights into customer lifetime value (LTV) and product lifecycles.

---

## 🏗️ My Contributions & Data Modeling

My core responsibilities in this project focused on data modeling, transformation, and high-level analytics:

1. **Schema Extension (DDL & ELT):** 
   - Designed and deployed Star Schema components (`gold_dim_customers`, `gold_dim_products`, `gold_fact_sales`) using MySQL.
   - Generated **Surrogate Keys** via window functions to decouple the reporting layer from source system operational keys.
   - Established Master Data Management (MDM) rules using conditional logic to merge conflicting CRM and ERP systems.
   - Handled database-specific anomalies (e.g., bypassing strict mode constraints to transform invalid `0000-00-00` dates into proper `NULL` values).

2. **Data Quality Assurance:**
   - Designed robust quality checks to validate primary key uniqueness and ensure strict referential integrity across the data model.

---

## 📂 Repository Structure

```text
├── 1_data_modeling/
│   ├── create_gold_views.sql     # DDL for the new Star Schema components
│   └── load_gold_layer.sql       # Ingestion logic & master data integration
├── 2_quality_checks/
│   └── gold_quality_checks.sql   # Referential integrity & primary key validations
└── 3_advanced_analytics/
    ├── 1_exploration_measures.sql # Core KPIs, descriptive stats & base exploration
    ├── 2_magnitude_analysis.sql   # Volume-based metrics & high-impact revenue drivers
    ├── 3_ranking_analysis.sql     # Top/bottom performance, sales velocity & tiering
    ├── 4_data_segmentation.sql    # Value-based customer tiering (e.g., Low, Mid, High)
    ├── 5_customer_report.sql      # Consolidated master customer lifetime value (LTV) report
    └── 6_product_report.sql       # Consolidated product lifecycle and performance report
