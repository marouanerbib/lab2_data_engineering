 Google Play Store Data Pipeline (dbt & DuckDB)

This project implements a modular analytical data pipeline using **dbt Core** and **DuckDB**, following Kimball dimensional modeling. Raw Google Play Store metadata and user reviews are transformed into an analytics-ready star schema.

## Project Architecture

1. **Staging Layer**: Raw JSON/JSONL files are ingested using DuckDB JSON readers, then renamed, type-cast, and quality-checked.
2. **Dimensional Layer**:
   - `dim_apps`
   - `dim_developers`
   - `dim_categories`
   - `dim_date`
3. **Fact Layer**:
   - `fact_reviews` (incremental, review grain = one row per `review_id`)

## Key Features

- **SCD Type 2 snapshot** for app metadata changes (`snapshots/apps_snapshot.sql`).
- **Incremental fact loading** for `fact_reviews` using `review_at` watermark.
- **Data quality tests** for keys, relationships, and value ranges.
- **Surrogate keys** generated with `dbt_utils.generate_surrogate_key`.

## Getting Started

### 1) Configure profile
Copy the example profile and adjust if needed:

```bash
mkdir -p ~/.dbt
cp profiles.yml.example ~/.dbt/profiles.yml
```

### 2) Install packages
```bash
dbt deps
```

### 3) Build models
```bash
dbt run
```

### 4) Run tests
```bash
dbt test
```

### 5) Run snapshots (SCD2)
```bash
dbt snapshot
```

## Expected built models

- Staging: `stg_playstore_apps`, `stg_playstore_reviews`
- Dimensions: `dim_apps`, `dim_developers`, `dim_categories`, `dim_date`
- Fact: `fact_reviews`
- Snapshot: `apps_snapshot`
