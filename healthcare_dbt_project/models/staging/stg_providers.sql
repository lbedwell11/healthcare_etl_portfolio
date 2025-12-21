with

source as (

    select
        provider_id,
        provider_name,
        department,
        specialty
    from {{ source('seeds', 'providers')}}

)

select
    provider_id,
    provider_name,
    department,
    specialty
from source
