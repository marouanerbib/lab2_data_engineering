# Google Play Store Data Pipeline (dbt & DuckDB)

This project implements a modular analytical data pipeline using **dbt Core** and **DuckDB**, following the Kimball dimensional modeling methodology. It transforms raw Google Play Store metadata and user reviews into an analytics-ready star schema.

## Project Architecture

The pipeline is structured into three logical layers:

1.  **Staging Layer**: Raw JSONL files are ingested using DuckDB's native JSON reader. Data is cleaned, columns are renamed for consistency, and basic types are enforced.
2.  **Dimensional Layer**: Descriptive entities are modeled with surrogate keys (MD5 hashes).
    *   `dim_apps`: Central application metadata.
    *   `dim_developers`: Unique developer information.
    *   `dim_categories`: App genres and categories.
    *   `dim_date`: A conformed date dimension for time-series analysis.
3.  **Fact Layer**: The central grain of the model.
    *   `fact_reviews`: Captures individual review events, scores, and timestamps linked to the dimensions.

## Key Features

*   **SCD Type 2**: Historical tracking of app metadata (like category and price changes) using dbt Snapshots.
*   **Incremental Loading**: The fact table uses incremental materialization to efficiently process new batches of reviews.
*   **Data Quality**: Robust schema tests ensure uniqueness, referential integrity, and value ranges across all layers.
*   **Surrogate Keys**: Use of `dbt_utils` for reliable cross-joining in the star schema.

## Getting Started

### Prerequisites
*   Python 3.8+
*   dbt-core
*   dbt-duckdb

### Installation
1. Install dependencies:
   ```bash
   dbt deps
   ```

2. Run the pipeline:
   ```bash
   dbt run
   ```

3. Validate the data:
   ```bash
   dbt test
   ```

4. Capture snapshots (SCD2):
   ```bash
   dbt snapshot
   ```

## Repository Structure
*   `models/staging/`: Initial cleanup and type casting.
*   `models/marts/dimensions/`: Descriptive business entities.
*   `models/marts/facts/`: Quantitative event data.
*   `snapshots/`: Logic for tracking slowly changing dimensions.
*   `data/raw/`: Landing zone for raw JSON ingest files (ignored by git).
