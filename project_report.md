# Lab 2: Data Pipeline with dbt & DuckDB - Project Report

## Project Overview
The objective of this project was to re-engineer a data pipeline using standard data engineering frameworks, moving away from ad-hoc Python logic to a robust, modular architecture. DuckDB serves as the analytical database engine, while dbt (data build tool) manages the transformation logic, data modeling, and validation.

## 1. Objectives and Environment Setup
Following the lab requirements, we established a local development environment for Google Play Store data analytics.
- **Tools**: Installed `dbt-core` and the `dbt-duckdb` adapter.
- **Storage**: Initialized a DuckDB database (`dev.duckdb`) to store the analytical layers.
- **Connection**: Configured `profiles.yml` to enable dbt to execute queries directly against the local DuckDB instance.

## 2. Dimensional Modeling (Kimball Methodology)
We adopted the Kimball approach for dimensional modeling to prioritize analytical exploration over transactional consistency.
- **Business Process**: The activity measured is the user review event on the Google Play Store.
- **Grain**: One row in the fact table represents a single review event for a specific app at a specific point in time.
- **Dimensions**: Apps, Categories, Developers, and Time (Date).
- **Facts**: Review scores and thumbs-up counts.

## 3. Staging Layer
The staging layer acts as a controlled interface between raw JSON/JSONL data and downstream transformations.
- **Models**: `stg_playstore_apps` and `stg_playstore_reviews`.
- **Logic**: Used DuckDB's `read_json_auto` to parse raw source files. Renamed columns to snake_case, performed type casting, and handled deduplication (specifically for reviews using unique `review_id`).
- **Data Quality**: Applied dbt schema tests (`not_null`, `unique`, `relationships`) to ensure structural integrity.

## 4. Serving Layer: Dimensions and Facts
We built an analytics-ready Star Schema in the `marts` directory.

### Dimensions
- **`dim_developers` & `dim_categories`**: Isolated unique descriptive attributes from the apps metadata.
- **`dim_date`**: Created a conformed date dimension using review timestamps to support time-series analysis (Year, Quarter, Month, etc.).
- **`dim_apps`**: A comprehensive app dimension using surrogate keys (`app_sk`) generated via `dbt_utils`.

### Fact Table
- **`fact_reviews`**: Links foreign keys from the dimension tables with measurable metrics. It serves as the primary source for BI visualizations, such as average rating trends and developer performance comparisons.

## 5. Advanced Features & Chaos Engineering

### Incremental Loading
To handle large volumes of data and daily batches, the `fact_reviews` table was configured with **Incremental Materialization**. On subsequent runs, dbt only processes and inserts reviews with a timestamp newer than the existing records in the table, significantly improving performance.

### Slowly Changing Dimensions (SCD Type 2)
To track historical changes in app metadata (e.g., price updates or category shifts), we implemented **SCD Type 2** using dbt snapshots.
- **Snapshot Logic**: Monitored specific columns (`price`, `title`, etc.) in `apps_snapshot`.
- **History Retention**: dbt automatically maintains `dbt_valid_from` and `dbt_valid_to` columns.
- **Integration**: The fact table was updated to join with `dim_apps_scd`, ensuring that review events are linked to the specific version of the app metadata that was valid at the time the review was written.

---
**Authors:**
- Ilyass Elkhezan
- Rbib Marouane
