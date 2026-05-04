with

stg_calendar as (

    select
        calendar_date,
        fiscal_year,
        fiscal_year_period
    from {{ ref('stg_calendar') }}

),

stg_providers as (

    select
        provider_id,
        provider_name,
        department,
        specialty
    from {{ ref('stg_providers') }}

),

stg_billing_charges as (

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
        amount,
        _ingested_at as _updated_at
    from {{ ref('stg_billing_charges') }}

),

provider_department_revenue as (

    select
        stg_calendar.fiscal_year,
        stg_calendar.fiscal_year_period,
        stg_providers.department as provider_department,
        stg_providers.specialty as provider_specialty,
        sum(stg_billing_charges.quantity) as billed_units,
        sum(stg_billing_charges.amount) as total_charges,
        max(stg_billing_charges._updated_at) as _updated_at
    from stg_billing_charges
    left join stg_providers
        on stg_billing_charges.service_provider_id = stg_providers.provider_id
    left join stg_calendar
        on stg_billing_charges.posted_date = stg_calendar.calendar_date
    group by
        stg_calendar.fiscal_year,
        stg_calendar.fiscal_year_period,
        stg_providers.department,
        stg_providers.specialty

)

select
    {{ dbt_utils.generate_surrogate_key([
        'fiscal_year_period',
        'provider_department',
        'provider_specialty'
        ]) }} as provider_revenue_key,
    fiscal_year,
    fiscal_year_period,
    provider_department,
    provider_specialty,
    billed_units,
    total_charges,
    _updated_at
from provider_department_revenue
