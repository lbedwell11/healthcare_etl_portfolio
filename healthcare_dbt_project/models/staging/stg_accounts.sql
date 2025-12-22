with

source as (

    select
        cast(account as varchar) as account,
        account_name,
        account_type,
        account_level1,
        account_level2
    from {{ source('seeds', 'accounts') }}

)

select
    account,
    account_name,
    account_type,
    account_level1,
    account_level2
from source
