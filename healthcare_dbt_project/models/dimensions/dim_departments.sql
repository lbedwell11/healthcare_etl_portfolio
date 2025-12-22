with

stg_departments as (

    select
        costcenter_id,
        entity_id,
        department_id,
        department_name,
        clinical_group
    from {{ref('stg_departments') }}

),

stg_entity as (

    select
        entity_id,
        entity_name
    from {{ ref('stg_entity') }}

),

dim_departments as (

    select
        stg_departments.costcenter_id,
        stg_departments.entity_id,
        stg_entity.entity_name,
        stg_departments.department_id,
        stg_departments.department_name,
        stg_departments.clinical_group
    from stg_departments
    left join stg_entity
        on stg_departments.entity_id = stg_entity.entity_id

)

select
    costcenter_id,
    entity_id,
    entity_name,
    department_id,
    department_name,
    clinical_group
from dim_departments
