{{ config(materialized='view') }}

select date,
marketing_source,
sum(round(marketing_costs::NUMERIC,2)) as marketing_costs

from 
{{ source('landing_layer', 'marketing_costs_dataset') }} raw

group by 1,2





