with

source as (

    select
        claim_id,
        member_id,
        provider_id,
        cast(service_date as date) as service_date,
        billed_amount,
        paid_amount,
        claim_status
    from {{ ref('claims') }}

)

select
    claim_id,
    member_id,
    provider_id,
    service_date,
    billed_amount,
    paid_amount,
    claim_status
from source
