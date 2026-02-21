with source as (
    select * from read_json_auto('data/raw/apps_metadata_raw.json')
),
renamed as (
    select
        appId as app_id,
        title as app_title,
        description as app_description,
        summary as app_summary,
        installs as app_installs_str,
        minInstalls as app_min_installs,
        realInstalls as app_real_installs,
        score as app_score,
        ratings as app_ratings,
        reviews as app_reviews,
        price as app_price,
        free as app_is_free,
        currency as app_currency,
        sale as app_is_on_sale,
        saleTime as app_sale_time,
        originalPrice as app_original_price,
        saleText as app_sale_text,
        offersIAP as app_offers_iap,
        inAppProductPrice as app_iap_price_range,
        developer as developer_name,
        developerId as developer_id,
        developerEmail as developer_email,
        developerWebsite as developer_website,
        developerAddress as developer_address,
        privacyPolicy as developer_privacy_policy,
        genre as category_name,
        genreId as category_id,
        icon as app_icon_url,
        headerImage as app_header_img_url,
        screenshots as app_screenshots,
        video as app_video_url,
        videoImage as app_video_img_url,
        contentRating as app_content_rating,
        contentRatingDescription as app_content_rating_desc,
        adSupported as app_ad_supported,
        containsAds as app_contains_ads,
        released as app_released_at,
        updated as app_updated_at_timestamp,
        version as app_version,
        comments as app_comments
    from source
)

select * from renamed
