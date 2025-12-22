with

stg_accounts as (
    
    select
        account,
        account_name,
        account_type,
        account_level1,
        account_level2
    from {{ ref('stg_accounts') }}

)

select
    account,
    account_name,
    account_type,
    account_level1,
    account_level2
from stg_accounts
