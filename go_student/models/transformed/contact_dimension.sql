{{ config(materialized='view') }}

select   
	distinct coalesce(cd.contact_id,ld.contact_id) as contact_id,
    substring(ld.create_date,1,7) AS lead_creation_year_month,
	substring(cd.customer_date,1,7) AS conversion_year_month,
	substring(calld.trial_date,1,7) AS trial_year_month,
    ld.known_city,
    case when ld.test_flag is TRUE then 1 else 0 end as test_flag,
	ld.marketing_source,
    --If contact_id is null in lead dataset, that probably means the customer converted organically without 
	--any sales call. We consider source as 'Organic' for those conversions. 
	case when substring(cd.customer_date,1,7) is null then NULL 
		else coalesce(ld.marketing_source,'Organic') end as conversion_source,  
	cd.contract_length,
    cast(REPLACE(avg_clv,',','') as float) as avg_clv,
	message_length,
	call_attempts,
	calls_30
	
from 
	{{ source('landing_layer', 'customer_dataset') }} cd 

full outer join 
	{{ source('landing_layer', 'lead_dataset') }} ld
        on cd.contact_id = ld.contact_id 

left join 
	{{ source('landing_layer', 'call_dataset') }} calld
        on calld.contact_id = ld.contact_id 
		
left join 
	{{ source('landing_layer', 'clv_dataset') }} clv
        on clv.contract_length = cd.contract_length
