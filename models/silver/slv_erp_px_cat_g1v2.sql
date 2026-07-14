with erp_px_cat_g1v2 as (
    select * from {{ source('bronze', 'erp_px_cat_g1v2') }}
)
SELECT
			id,
			cat,
			subcat,
			maintenance
		FROM erp_px_cat_g1v2