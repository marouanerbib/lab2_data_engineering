{{
    config(
        materialized='incremental',
        unique_key='review_id'
    )
}}

with reviews as (
    select
        review_id,
        app_id,
        review_score,
        review_thumbs_up_count,
        review_at,
        review_replied_at,
        review_content,
        review_reply_content,
        user_name,
        app_version_reviewed,
        review_created_version
    from {{ ref('stg_playstore_reviews') }}
    {% if is_incremental() %}
    where review_at > (select coalesce(max(review_at), cast('1900-01-01' as timestamp)) from {{ this }})
    {% endif %}
)

select
    r.review_id,
    a.app_sk,
    d.developer_sk,
    c.category_sk,
    dt.date_sk,
    r.app_id,
    r.review_at,
    r.review_replied_at,
    r.review_score,
    r.review_thumbs_up_count,
    r.review_content,
    r.review_reply_content,
    r.user_name,
    r.app_version_reviewed,
    r.review_created_version
from reviews r
left join {{ ref('dim_apps') }} a
    on r.app_id = a.app_id
left join {{ ref('dim_developers') }} d
    on coalesce(nullif(trim(a.developer_id), ''), trim(a.developer_name)) = d.developer_nk
left join {{ ref('dim_categories') }} c
    on coalesce(nullif(trim(a.category_id), ''), trim(a.category_name)) = c.category_nk
left join {{ ref('dim_date') }} dt
    on cast(r.review_at as date) = dt.date_day
