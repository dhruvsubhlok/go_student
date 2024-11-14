{{ config(materialized='view') }}

with cte as (

    select conversion_year_month,
    cd.marketing_source,
    sum(round(avg_clv::NUMERIC,2)) as revenue

    from 
        {{ ref("contact_dimension") }} cd

    group by 1,2
)

select conversion_year_month as year_month,
    cte.marketing_source,
    revenue / sum(marketing_costs) as roi

from cte    

inner join 
        {{ ref("marketing_costs_agg") }} mca
            on mca.date = cte.conversion_year_month
            and mca.marketing_source = cte.marketing_source

group by 1,2,revenue