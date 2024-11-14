{{ config(materialized="view") }}


with CTE as 
(
    select ld.contact_id, 
    cast(ld.create_date AS date) as lead_create_date,
    cast(cd.trial_date AS date) as trial_booking_date

    from
        {{ source('landing_layer', 'call_dataset') }} cd
            
    inner join         
        {{ source('landing_layer', 'lead_dataset') }} ld
            on ld.contact_id = cd.contact_id
)

select contact_id, 
    (trial_booking_date-lead_create_date) as time_to_trial

from 
    CTE
    