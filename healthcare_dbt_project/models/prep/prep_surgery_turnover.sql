with

dim_calendar as (

    select
        calendar_date,
        fiscal_year,
        fiscal_year_period
    from {{ ref('stg_calendar') }}

),

stg_surgery as (

    select
        surgery_case_key,
        surgery_case_id,
        hospital_account_id,
        mrn,
        posted_date,
        status as case_status,
        scheduled_start_time,
        actual_start_time,
        actual_end_time,
        or_room,
        is_emergency_case,
        _ingested_at as _updated_at
    from {{ ref('stg_surgery') }}
    where is_completed_case

),

surgery_times as (

    select
        surgery.surgery_case_key,
        surgery.surgery_case_id,
        surgery.hospital_account_id,
        surgery.mrn,
        surgery.posted_date,
        surgery.case_status,
        surgery.scheduled_start_time,
        surgery.actual_start_time,
        surgery.actual_end_time,
        surgery.or_room,
        surgery.is_emergency_case,
        surgery._updated_at,
        cal.fiscal_year,
        cal.fiscal_year_period,
        datediff('minute', surgery.scheduled_start_time, surgery.actual_start_time) as on_time_minutes,
        datediff('minute', surgery.actual_start_time, surgery.actual_end_time) as surgery_minutes 
    from stg_surgery as surgery
    left join dim_calendar as cal
        on surgery.posted_date = cal.calendar_date

)

select
    {{ dbt_utils.generate_surrogate_key ([
        'surgery_case_id',
        'hospital_account_id'
    ]) }} as surgery_turnover_key,
    surgery_case_key,
    fiscal_year,
    fiscal_year_period,
    surgery_case_id,
    hospital_account_id,
    mrn,
    posted_date,
    case_status,
    or_room,
    is_emergency_case,
    on_time_minutes,
    surgery_minutes,
    _updated_at
from surgery_times
