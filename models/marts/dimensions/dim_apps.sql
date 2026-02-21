with stg_apps as (
    select * from {{ ref('stg_playstore_apps') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['app_id']) }} as app_sk,
    app_id as app_natural_key,
    app_title,
    app_description,
    app_summary,
    app_icon_url,
    app_header_img_url,
    app_content_rating,
    app_content_rating_desc,
    app_ad_supported,
    app_contains_ads,
    app_released_at,
    app_version,
    app_is_free,
    app_currency,
    app_offers_iap,
    app_iap_price_range,
    app_original_price,
    {{ dbt_utils.generate_surrogate_key(['developer_id']) }} as developer_sk,
    {{ dbt_utils.generate_surrogate_key(['category_id']) }} as category_sk
from stg_apps
where app_id is not null
