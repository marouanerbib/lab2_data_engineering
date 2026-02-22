with categories as (
    select distinct
        coalesce(nullif(trim(category_id), ''), trim(category_name)) as category_nk,
        category_id,
        category_name
    from {{ ref('stg_playstore_apps') }}
    where coalesce(nullif(trim(category_id), ''), trim(category_name)) is not null
)

select
    {{ dbt_utils.generate_surrogate_key(['category_nk']) }} as category_sk,
    category_nk,
    category_id,
    category_name
from categories
