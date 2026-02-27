select
    surgery_turnover_key,
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
    surgery_minutes
from {{ ref('prep_surgery_turnover' )}}
