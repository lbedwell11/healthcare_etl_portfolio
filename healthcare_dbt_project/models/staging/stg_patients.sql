with

source as (

    select
        mrn,
        first_name,
        last_name,
        concat(first_name, ' ', last_name) as full_name,
        cast(date_of_birth as date) as date_of_birth,
        gender
    from {{ source('seeds', 'patients') }}

)

select
    mrn,
    first_name,
    last_name,
    full_name,
    date_of_birth,
    gender
from source
