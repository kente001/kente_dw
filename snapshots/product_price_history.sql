{% snapshot snap_prd_cost %}

{{
    config(
        target_schema='kente_snapshots',
        unique_key='prd_key',
        strategy='check',
        check_cols=['prd_cost'],
        invalidate_hard_deletes=true
    )
}}

select
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
from {{ ref('slv_crm_prd_info') }}
where prd_end_dt is null

{% endsnapshot %}