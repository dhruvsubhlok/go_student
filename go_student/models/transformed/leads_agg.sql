{{ config(materialized='view') }}

select   
	lead_creation_year_month,
	marketing_source,
    known_city,
    test_flag,
    avg(ld.message_length) as avg_message_length,
    count(distinct contact_id) as leads_count
from 
	{{ ref('contact_dimension') }} ld

group by 1,2,3,4