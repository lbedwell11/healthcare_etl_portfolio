with

source as (

    select
        provider_id,
        provider_name,
        specialty
    from {{ ref('providers')}}

)

select
    provider_id,
    provider_name,
    specialty
from source
