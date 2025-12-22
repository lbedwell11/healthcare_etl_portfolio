with

source as (

    select
        surgery_case_id,
        cast(hospital_account_id as varchar) as hospital_account_id,
        cast(mrn as varchar) as mrn,
        cast(entity_id as varchar) as entity_id,
        cast(department_id as varchar) as department_id,
        service_line,
        service_provider,
        cast(service_date as date) as service_date,
        cast(posted_date as date) as posted_date,
        status,
        cast(scheduled_start_time as datetime) as scheduled_start_time,
        cast(actual_start_time as datetime) as actual_start_time,
        cast(actual_end_time as datetime) as actual_end_time,
        cast(cpt_hcpcs_code as varchar) as cpt_hcpcs_code,
        or_room,
        case 
            when emergency_flag = 'Y' then 1 
            else 0 
            end as is_emergency_case
    from {{ source('seeds', 'surgery') }}

)

select
    surgery_case_id,
    hospital_account_id,
    mrn,
    entity_id,
    department_id,
    service_line,
    service_provider,
    service_date,
    posted_date,
    status,
    scheduled_start_time,
    actual_start_time,
    actual_end_time,
    cpt_hcpcs_code,
    or_room,
    is_emergency_case
from source
