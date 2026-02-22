{% snapshot apps_snapshot %}

{{
    config(
      target_schema='snapshots',
      unique_key='app_id',
      strategy='timestamp',
      updated_at='app_updated_at_timestamp'
    )
}}

select * from {{ ref('stg_playstore_apps') }}

{% endsnapshot %}
