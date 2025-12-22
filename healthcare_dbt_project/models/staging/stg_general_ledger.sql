with

source as (

    select
        cast(journal_id as varchar) as journal_id,
        cast(post_date as date) as post_date,
        cast(entity_id as varchar) as entity_id,
        cast(department_id as varchar) as department_id,
        cast(account as varchar) as account,
        cast(fund as varchar) as fund,
        description as journal_description,
        cast(amount as float) as amount,
        concat(
            left(cast(entity_id as varchar), 2),
            cast(department_id as varchar)) as costcenter_id
    from {{ source('seeds', 'general_ledger') }}

)

select
    {{ dbt_utils.generate_surrogate_key([
        'costcenter_id',
        'journal_id',
        'post_date',
        'account',
        'fund',
        'journal_description']
        ) }} as general_ledger_key,
    costcenter_id,
    journal_id,
    post_date,
    entity_id,
    department_id,
    account,
    fund,
    journal_description,
    amount
from source
