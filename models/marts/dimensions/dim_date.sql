with dates as (
    select distinct cast(review_at as date) as date_day
    from {{ ref('stg_playstore_reviews') }}
    where review_at is not null
)

select
    {{ dbt_utils.generate_surrogate_key(['date_day']) }} as date_sk,
    date_day,
    extract(year from date_day) as year,
    extract(quarter from date_day) as quarter,
    extract(month from date_day) as month,
    extract(day from date_day) as day_of_month,
    extract(week from date_day) as week_of_year,
    extract(isodow from date_day) as iso_day_of_week,
    strftime(date_day, '%A') as day_name,
    strftime(date_day, '%B') as month_name
from dates
