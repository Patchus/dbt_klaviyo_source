
with base as (

    select * 
    from {{ ref('stg_klaviyo__metric_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_klaviyo__metric_tmp')),
                staging_columns=get_metric_columns()
            )
        }}
        {{ fivetran_utils.source_relation(
            union_schema_variable='klaviyo_union_schemas', 
            union_database_variable='klaviyo_union_databases') 
        }}
    from base
),

final as (
    
    select 
        created as created_at,
        id as metric_id,
        integration_id,
        name as metric_name,
        updated as updated_at,
        source_relation

    from fields

    where not coalesce(_fivetran_deleted, false)
)

select * from final