with

stg_members as (

    select
        member_id,
        first_name,
        last_name,
        full_name,
        date_of_birth,
        gender
    from {{ ref('stg_members') }}

),

dim_members as (

    select
        member_id,
        first_name,
        last_name,
        full_name,
        date_of_birth,
        gender,
        datediff('year', date_of_birth::date, today()) as member_age
    from stg_members

)

select
    member_id,
    first_name,
    last_name,
    full_name,
    date_of_birth,
    gender,
    member_age
from dim_members
