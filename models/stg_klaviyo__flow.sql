
with base as (

    select * 
    from {{ ref('stg_klaviyo__flow_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_klaviyo__flow_tmp')),
                staging_columns=get_flow_columns()
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
        cast(id as {{ dbt.type_string() }} ) as flow_id,
        name as flow_name,
        status,
        {% if target.type == 'snowflake'%}
        "TRIGGER" 
        {% else %}
        trigger
        {% endif %}
        as flow_trigger,
        updated as updated_at,
        customer_filter as person_filter,
        source_relation

    from fields
    where not coalesce(_fivetran_deleted, false)
)

select * from final