with

source as (

    select
        cast(transaction_id as varchar) as transaction_id,
        cast(hospital_account_id as varchar) as hospital_account_id,
        cast(entity_id as varchar) as entity_id,
        cast(department_id as varchar) as department_id,
        cast(service_date as date) as service_date,
        cast(posted_date as date) as posted_date,
        cast(account as varchar) as account,
        cast(fund as varchar) as fund,
        cast(cpt_hcpcs_code as varchar) as cpt_hcpcs_code,
        cast(service_provider as varchar) as service_provider_id,
        cast(quantity as float) as quantity,
        cast(amount as float) as amount
    from {{ source('seeds', 'billing_charges') }}
    
)

select
    transaction_id,
    hospital_account_id,
    entity_id,
    department_id,
    service_date,
    posted_date,
    account,
    fund,
    cpt_hcpcs_code,
    service_provider_id,
    quantity,
    amount
from source
