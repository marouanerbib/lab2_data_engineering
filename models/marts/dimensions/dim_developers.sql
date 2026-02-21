with stg_apps as (
    select * from {{ ref('stg_playstore_apps') }}
),
unique_developers as (
    select distinct
        developer_id,
        developer_name,
        developer_email,
        developer_website,
        developer_address,
        row_number() over (partition by developer_id order by developer_name) as rn
    from stg_apps
    where developer_id is not null
)

select
    {{ dbt_utils.generate_surrogate_key(['developer_id']) }} as developer_sk,
    developer_id as developer_natural_key,
    developer_name,
    developer_email,
    developer_website,
    developer_address
from unique_developers
where rn = 1
