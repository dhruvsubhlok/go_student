{{ config(materialized="view")
 }}

select year_month,
round((revenue/total_sales_costs)::NUMERIC,2) as ser

from 
    {{ ref("sales_efficiency_ratio") }} ser