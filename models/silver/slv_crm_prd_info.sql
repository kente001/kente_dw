
with crm_prd_info as (

    select * from {{ source('bronze', 'crm_prd_info') }}

)

select
    prd_id,
    replace(substring(prd_key, 1, 5), '-', '_') as cat_id,
    substring(prd_key, 7) as prd_key,
    prd_nm,
    coalesce(prd_cost, 0) as prd_cost,
    case upper(trim(prd_line))
        when 'M' then 'Mountain'
        when 'R' then 'Road'
        when 'S' then 'Other Sales'
        when 'T' then 'Touring'
        else 'n/a'
    end as prd_line,
    cast(prd_start_dt as date) as prd_start_dt,
    cast(
        date_sub(
            lead(prd_start_dt) over (partition by prd_key order by prd_start_dt),
            interval 1 day
        ) as date
    ) as prd_end_dt
from crm_prd_info