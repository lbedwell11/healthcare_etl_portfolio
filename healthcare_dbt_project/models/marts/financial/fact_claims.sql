with

stg_calendar as (

    select
        calendar_date,
        fiscal_year_period,
        fiscal_year
    from {{ ref('stg_calendar') }}

),

stg_claims as (

    select
        claim_id,
        mrn,
        hospital_account_id,
        entity_id,
        service_date,
        posted_date,
        billed_amount,
        paid_amount,
        claim_status
    from {{ ref('stg_claims') }}

),

fact_claims as (

    select
        stg_claims.claim_id,
        stg_claims.mrn,
        stg_claims.hospital_account_id,
        stg_claims.entity_id,
        stg_claims.service_date,
        stg_claims.posted_date,
        stg_calendar.fiscal_year_period,
        stg_claims.billed_amount,
        stg_claims.paid_amount,
        stg_claims.claim_status
    from stg_claims
    left join stg_calendar
        on stg_claims.posted_date = stg_calendar.calendar_date

)

select
    claim_id,
    fiscal_year_period,
    mrn,
    hospital_account_id,
    entity_id,
    service_date,
    posted_date,
    billed_amount,
    paid_amount,
    claim_status
from fact_claims
