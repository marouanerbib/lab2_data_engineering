with base as (
    select
        coalesce(nullif(trim(developer_id), ''), trim(developer_name)) as developer_nk,
        nullif(trim(developer_id), '') as developer_id,
        nullif(trim(developer_name), '') as developer_name,
        nullif(trim(developer_email), '') as developer_email,
        nullif(trim(developer_website), '') as developer_website,
        nullif(trim(developer_address), '') as developer_address,
        nullif(trim(developer_privacy_policy), '') as developer_privacy_policy
    from {{ ref('stg_playstore_apps') }}
    where coalesce(nullif(trim(developer_id), ''), trim(developer_name)) is not null
),
ranked as (
    select
        *,
        row_number() over (
            partition by developer_nk
            order by
                (developer_id is not null) desc,
                (developer_email is not null) desc,
                (developer_website is not null) desc,
                (developer_address is not null) desc,
                (developer_privacy_policy is not null) desc
        ) as rn
    from base
)

select
    {{ dbt_utils.generate_surrogate_key(['developer_nk']) }} as developer_sk,
    developer_nk,
    developer_id,
    developer_name,
    developer_email,
    developer_website,
    developer_address,
    developer_privacy_policy
from ranked
where rn = 1
