{{ config(materialized='view') }}

select distinct coalesce(ca.conversion_year_month,la.lead_creation_year_month) as year_month,
coalesce(ca.conversion_source,la.marketing_source) as source,
la.test_flag as test_flag,
la.known_city as known_city,
round(coalesce(conversion_count,0)::NUMERIC,2) as conversion_count,
round(coalesce(leads_count,0)::NUMERIC,2) as leads_count

from 
    {{ ref("conversions_agg") }} ca

full outer join 
    {{ ref("leads_agg") }} la
        on ca.conversion_year_month = la.lead_creation_year_month
        and ca.conversion_source = la.marketing_source
        and ca.test_flag = la.test_flag
        and ca.known_city = la.known_city



