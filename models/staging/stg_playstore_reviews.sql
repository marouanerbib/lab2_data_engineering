with source as (
    select * from read_json_auto('data/raw/user_reviews_raw.jsonl')
),
renamed as (
    select
        reviewId as review_id,
        userName as user_name,
        userImage as user_image,
        content as review_content,
        score as review_score,
        thumbsUpCount as review_thumbs_up_count,
        reviewCreatedVersion as review_created_version,
        "at" as review_at,
        replyContent as review_reply_content,
        repliedAt as review_replied_at,
        appVersion as app_version_reviewed,
        appId as app_id,
        row_number() over (partition by reviewId order by "at" desc) as rn
    from source
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
from renamed
where rn = 1
