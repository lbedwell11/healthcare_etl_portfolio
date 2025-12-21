with

source as (

    select
        cast(entity_id as varchar) as entity_id,
        cast(department_id as varchar) as department_id,
        department_name,
        clinical_group,
        concat(
            left(cast(entity_id as varchar), 2),
            cast(department_id as varchar)
            ) as costcenter_id
    from {{ source('seeds', 'departments') }}

)

select
    costcenter_id,
    entity_id,
    department_id,
    department_name,
    clinical_group
from source
