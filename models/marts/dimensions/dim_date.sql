with stg_reviews as (
    select * from {{ ref('stg_playstore_reviews') }}
),
raw_dates as (
    select distinct
        cast(review_at as date) as review_date
    from stg_reviews
    where review_at is not null
),
date_dimension as (
    select
        -- date natural key in format YYYYMMDD
        cast(strftime(review_date, '%Y%m%d') as integer) as date_key,
        review_date as date_actual,
        extract(year from review_date) as year,
        extract(month from review_date) as month,
        extract(day from review_date) as day,
        extract(quarter from review_date) as quarter,
        extract(isodow from review_date) as day_of_week
    from raw_dates
)

select * from date_dimension
