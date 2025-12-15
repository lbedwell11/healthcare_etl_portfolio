with

source as (

    select
        member_id,
        first_name,
        last_name,
        concat(first_name, ' ', last_name) as full_name,
        cast(date_of_birth as date) as date_of_birth,
        gender
    from {{ source('seeds', 'members') }}

)

select
    member_id,
    first_name,
    last_name,
    full_name,
    date_of_birth,
    gender
from source
