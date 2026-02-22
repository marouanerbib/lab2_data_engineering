with source as (
    select * from read_json_auto('data/raw/user_reviews_raw.json*')
),
typed as (
    select
        reviewId as review_id,
        userName as user_name,
        userImage as user_image,
        content as review_content,
        try_cast(score as integer) as review_score,
        try_cast(thumbsUpCount as bigint) as review_thumbs_up_count,
        reviewCreatedVersion as review_created_version,
        try_cast("at" as timestamp) as review_at,
        replyContent as review_reply_content,
        try_cast(repliedAt as timestamp) as review_replied_at,
        appVersion as app_version_reviewed,
        appId as app_id
    from source
),
deduplicated as (
    select
        *,
        row_number() over (
            partition by review_id
            order by review_at desc nulls last
        ) as rn
    from typed
)

select
    review_id,
    user_name,
    user_image,
    review_content,
    review_score,
    review_thumbs_up_count,
    review_created_version,
    review_at,
    review_reply_content,
    review_replied_at,
    app_version_reviewed,
    app_id
from deduplicated
where rn = 1
