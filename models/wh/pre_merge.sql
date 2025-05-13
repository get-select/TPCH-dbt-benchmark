{{
    config(
        materialized = 'view',
        tags = ['merge-test']
    )
}}

with row_count as (
    select count(*) as total_rows
    from {{ ref('fct_orders_items') }}
),
sampled_data as (
    select 
        *,
        row_number() over (order by random()) as row_num
    from {{ ref('fct_orders_items') }}
),
final as (
    select * exclude (dbt_batch_id, DBT_BATCH_TS)
    from sampled_data
    where 
    row_num <= (select cast(total_rows * 0.00005 as integer) from row_count)
    {# row_num < 101 #}
)

select 
    f.*,
    {{ dbt_housekeeping() }}
from final f
order by f.order_date



