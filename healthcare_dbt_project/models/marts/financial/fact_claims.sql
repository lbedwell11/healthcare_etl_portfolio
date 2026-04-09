with

int_claims as (
    
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
        claim_status,
        _updated_at
    from {{ ref('int_claims') }}

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
    claim_status,
    _updated_at
from int_claims
