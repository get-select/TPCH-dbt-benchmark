-- depends_on: {{ ref('pre_merge') }}
-- depends_on: {{ ref('fct_orders_items') }}

{{
  config(
    materialized = 'incremental',
    unique_key = 'order_item_key',
    merge_strategy = 'merge',
    tags = ['merge-test']
    )
}}

-- if incremental, select * from pre_merge else select * from fct_orders_items
select
*
from
    {% if is_incremental() %}
        {{ ref('pre_merge') }}
    {% else %}
        {{ ref('fct_orders_items') }}
    {% endif %}

