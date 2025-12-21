with

stg_patients as (

    select
        mrn,
        first_name,
        last_name,
        full_name,
        date_of_birth,
        gender
    from {{ ref('stg_patients') }}

),

dim_patients as (

    select
        mrn,
        first_name,
        last_name,
        full_name,
        date_of_birth,
        gender,
        datediff('year', date_of_birth::date, today()) as patient_age
    from stg_patients

)

select
    mrn,
    first_name,
    last_name,
    full_name,
    date_of_birth,
    gender,
    patient_age
from dim_patients
