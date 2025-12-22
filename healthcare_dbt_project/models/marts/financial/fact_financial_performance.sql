{{
    config(
        materialized = 'table'
        )
}}
--Financial performance models are rebuilt in full because GL data can be adjusted retroactively.
with

stg_calendar as (

    select
        calendar_date,
        fiscal_year_period,
        fiscal_year
    from {{ ref('stg_calendar') }}

),

stg_general_ledger as (

    select
        general_ledger_key,
        costcenter_id,
        journal_id,
        post_date,
        entity_id,
        department_id,
        account,
        fund,
        journal_description,
        amount
    from {{ ref('stg_general_ledger') }}

),

financial_performance as (

    select
        stg_general_ledger.general_ledger_key,
        stg_general_ledger.costcenter_id,
        stg_general_ledger.journal_id,
        stg_general_ledger.post_date,
        stg_calendar.fiscal_year_period,
        stg_general_ledger.entity_id,
        stg_general_ledger.department_id,
        stg_general_ledger.account,
        stg_general_ledger.fund,
        stg_general_ledger.journal_description,
        stg_general_ledger.amount
    from stg_general_ledger
    left join stg_calendar
        on stg_general_ledger.post_date = stg_calendar.calendar_date

)

select
    general_ledger_key,
    costcenter_id,
    journal_id,
    post_date,
    fiscal_year_period,
    entity_id,
    department_id,
    account,
    fund,
    journal_description,
    amount
from financial_performance
