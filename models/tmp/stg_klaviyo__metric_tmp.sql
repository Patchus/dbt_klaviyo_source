{{
    fivetran_utils.union_data(
        table_identifier='metric', 
        database_variable='fivetran_database', 
        schema_variable='fivetran_schema', 
        default_database=target.database,
        default_schema='fivetran',
        default_variable='metric_source'
    )
}}