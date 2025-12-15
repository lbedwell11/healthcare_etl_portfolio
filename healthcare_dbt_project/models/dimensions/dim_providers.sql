with

stg_providers as (

    select
        provider_id,
        provider_name,
        specialty
    from {{ ref('stg_providers') }}

)

select
    provider_id,
    provider_name,
    specialty
from stg_providers
