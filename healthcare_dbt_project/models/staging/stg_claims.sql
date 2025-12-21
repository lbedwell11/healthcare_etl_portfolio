with

source as (

    select
        claim_id,
        mrn,
        hospital_account_id,
        entity_id,
        cast(service_date as date) as service_date,
        cast(posted_date as date) as posted_date,
        billed_amount,
        paid_amount,
        claim_status
    from {{ source('seeds', 'claims') }}

)

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
from source
