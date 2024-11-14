{{ config(materialized='view') }}

select coalesce(mc.conversion_year_month,mcd.date) as year_month,
coalesce(mc.conversion_source,mcd.marketing_source) as conversion_source,
round(coalesce(marketing_costs,0)::NUMERIC,2) as marketing_costs,
round(sum(coalesce(conversion_count,0))::NUMERIC,2) as conversion_count,
case when conversion_count is null then FALSE else TRUE end as conversion_flag

from 
{{ ref("conversions_agg") }} mc

full outer join {{ ref('marketing_costs_agg') }} mcd
    on mc.conversion_year_month = mcd.date
    and mc.conversion_source = mcd.marketing_source

group by 1,2,3,5
