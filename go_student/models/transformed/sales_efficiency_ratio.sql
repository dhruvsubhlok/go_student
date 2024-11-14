{{ config(materialized='view') }}

with cte as 
(
    select conversion_year_month,
    sum(round(avg_clv::NUMERIC,2)) as revenue
    
    from 
        {{ ref("contact_dimension") }} 
    group by 1
)

select conversion_year_month as year_month,
sum(round(revenue::NUMERIC,2)) as revenue,
sum(round("Total Sales Costs"::NUMERIC,2)) as total_sales_costs

from cte

left join
        {{ source('landing_layer', 'sales_cost_dataset') }} scd   
            on cte.conversion_year_month = scd."Month"

group by 1




