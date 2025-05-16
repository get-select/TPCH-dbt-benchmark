-- depends_on: {{ ref('pre_merge') }}
-- depends_on: {{ ref('fct_orders_items') }}

{{
  config(
    materialized = 'incremental',
    unique_key = 'order_item_key',
    merge_strategy = 'merge',
    tags = ['merge-test'],
    pre_hook = ["ALTER SESSION SET USE_CACHED_RESULT = FALSE"]
    )
}}

-- if incremental, select * from pre_merge else select * from fct_orders_items
with source_data1 as (
select
*
from
    {% if is_incremental() %}
        {{ ref('pre_merge') }}
    {% else %}
        {{ ref('fct_orders_items') }}
    {% endif %}

)

select * from source_data1
