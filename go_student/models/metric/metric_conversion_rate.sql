{{ config(materialized="view") }}

select year_month,
source,
test_flag,
known_city,
case when leads_count > 0 then round((conversion_count/leads_count)::NUMERIC,2) else NULL end as conversion_rate

from 
    {{ ref("conversion_rate") }} ca