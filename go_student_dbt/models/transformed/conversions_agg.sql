{{ config(materialized='view') }}

select   
	conversion_year_month,
	conversion_source,  
	known_city,
	test_flag,
	count(distinct contact_id) as conversion_count
from 
	{{ ref('contact_dimension') }}

group by 1,2,3,4	