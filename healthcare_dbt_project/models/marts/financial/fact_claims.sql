with

stg_claims as (

    select
        claim_id,
        member_id,
        provider_id,
        service_date,
        posted_date,
        billed_amount,
        paid_amount,
        claim_status
    from {{ ref('stg_claims') }}

)

select
    claim_id,
    member_id,
    provider_id,
    service_date,
    posted_date,
    billed_amount,
    paid_amount,
    claim_status
from stg_claims
