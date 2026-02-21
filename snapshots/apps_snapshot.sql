{% snapshot apps_snapshot %}

{{
    config(
      target_schema='snapshots',
      unique_key='app_id',
      strategy='check',
      check_cols=['app_title', 'category_id', 'developer_id', 'app_price', 'app_is_free']
    )
}}

select * from {{ ref('stg_playstore_apps') }}

{% endsnapshot %}
