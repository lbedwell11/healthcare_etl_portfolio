with

source as (

    select
        cast(entity_id as varchar) as entity_id,
        entity_name
    from {{ source('seeds', 'entity') }}

)

select
    entity_id,
    entity_name
from source
