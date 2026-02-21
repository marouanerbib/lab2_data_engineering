with stg_apps as (
    select * from {{ ref('stg_playstore_apps') }}
),
unique_categories as (
    select distinct
        category_id,
        category_name
    from stg_apps
    where category_id is not null
)

select
    {{ dbt_utils.generate_surrogate_key(['category_id']) }} as category_sk,
    category_id as category_natural_key,
    category_name
from unique_categories
