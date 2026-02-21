{{
    config(
        materialized='incremental',
        unique_key='review_natural_key'
    )
}}

with stg_reviews as (
    select * from {{ ref('stg_playstore_reviews') }}
),
dim_apps as (
    select * from {{ ref('dim_apps_scd') }}
),
dim_date as (
    select * from {{ ref('dim_date') }}
)

select
    r.review_id as review_natural_key,
    a.app_scd_sk,
    d.date_key as review_date_key,
    
    -- measures
    r.review_score,
    r.review_thumbs_up_count,
    
    -- degenerative dimensions / review attributes
    r.user_name,
    r.review_content,
    r.review_created_version,
    r.app_version_reviewed,
    r.review_reply_content,
    r.review_at as review_timestamp,
    r.review_replied_at as review_replied_timestamp
    
from stg_reviews r
left join dim_apps a
    on r.app_id = a.app_natural_key
    and a.is_current = true
left join dim_date d
    on cast(strftime(r.review_at, '%Y%m%d') as integer) = d.date_key

{% if is_incremental() %}
  -- Filter for reviews that are newer than the last max date stored in the target table
  where r.review_at > (select max(review_timestamp) from {{ this }})
{% endif %}
