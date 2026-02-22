with developers as (
    select distinct
        coalesce(nullif(trim(developer_id), ''), trim(developer_name)) as developer_nk,
        developer_id,
        developer_name,
        developer_email,
        developer_website,
        developer_address,
        developer_privacy_policy
    from {{ ref('stg_playstore_apps') }}
    where coalesce(nullif(trim(developer_id), ''), trim(developer_name)) is not null
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
from developers
