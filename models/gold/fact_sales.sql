{{
    config(
        materialized='incremental',
        on_schema_change='fail'
    )
}}

with sales as (

    select * from {{ ref('slv_crm_sales_details') }}

    {% if is_incremental() %}
    where sls_order_dt > (
        select coalesce(max(order_date), '1900-01-01')
        from {{ this }}
    )
    {% endif %}

),

dim_product as (

    select * from {{ ref('dim_products') }}

),

dim_customer as (

    select * from {{ ref('dim_customers') }}

)

select
    sd.sls_ord_num  as order_number,
    pr.product_key  as product_key,
    cu.customer_key as customer_key,
    sd.sls_order_dt as order_date,
    sd.sls_ship_dt  as shipping_date,
    sd.sls_due_dt   as due_date,
    sd.sls_sales    as sales_amount,
    sd.sls_quantity as quantity,
    sd.sls_price    as price
from sales sd
left join dim_product pr
    on sd.sls_prd_key = pr.product_number
left join dim_customer cu
    on sd.sls_cust_id = cu.customer_id