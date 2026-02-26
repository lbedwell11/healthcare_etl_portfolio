with

dim_calendar as (

    select
        calendar_date,
        fiscal_year,
        fiscal_month,
        fiscal_year_period
    from {{ ref('stg_calendar') }}

),


surgery as (

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
        status as case_status,
        scheduled_start_time,
        actual_start_time,
        actual_end_time,
        cpt_hcpcs_code,
        or_room,
        is_emergency_case
    from {{ ref('stg_surgery') }}

),

billing_charges as (

    select
        hospital_account_id,
        entity_id,
        department_id,
        service_date,
        posted_date,
        sum(amount) as total_charges
    from {{ ref('stg_billing_charges') }}
    group by
        hospital_account_id,
        entity_id,
        department_id,
        service_date,
        posted_date

),

surgery_transactions as (

    select
        surgery.surgery_case_id,
        surgery.hospital_account_id,
        surgery.mrn,
        surgery.entity_id,
        surgery.department_id,
        surgery.service_line,
        surgery.service_provider,
        surgery.service_date,
        surgery.posted_date,
        surgery.case_status,
        surgery.scheduled_start_time,
        surgery.actual_start_time,
        surgery.actual_end_time,
        surgery.cpt_hcpcs_code,
        surgery.or_room,
        surgery.is_emergency_case,
        billing_charges.total_charges,
        dim_calendar.fiscal_year,
        dim_calendar.fiscal_year_period
    from surgery
    left join billing_charges
        on surgery.hospital_account_id = billing_charges.hospital_account_id
    left join dim_calendar
        on surgery.posted_date = dim_calendar.calendar_date

)

select
    {{ dbt_utils.generate_surrogate_key ([
        'surgery_case_id',
        'hospital_account_id'
    ]) }} as surgery_transactions_key,
    fiscal_year,
    fiscal_year_period,
    surgery_case_id,
    hospital_account_id,
    mrn,
    entity_id,
    department_id,
    service_line,
    service_provider,
    service_date,
    posted_date,
    case_status,
    scheduled_start_time,
    actual_start_time,
    actual_end_time,
    cpt_hcpcs_code,
    or_room,
    is_emergency_case,
    total_charges
from surgery_transactions
