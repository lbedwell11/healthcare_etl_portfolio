with

source as (

    select
        cast(claim_id as varchar) as claim_id,
        cast(mrn as varchar) as mrn,
        cast(hospital_account_id as varchar) as hospital_account_id,
        cast(entity_id as varchar) as entity_id,
        cast(service_date as date) as service_date,
        cast(posted_date as date) as posted_date,
        cast(billed_amount as float) as billed_amount,
        cast(paid_amount as float) as paid_amount,
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
