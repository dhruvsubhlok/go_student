{{ config(materialized='view') }}

select year_month,
conversion_source,
conversion_count,
case when conversion_count > 0 then round((marketing_costs/conversion_count),2) else NULL end as cac


from 
{{ ref("cac_agg") }} mc

