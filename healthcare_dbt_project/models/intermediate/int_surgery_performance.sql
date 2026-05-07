{{
    config(
        materialized='incremental',
        unique_key='surgery_performance_key'
    )
}}

with

surgery_transactions as (

    select
        surgery_case_key,
        fiscal_year,
        fiscal_year_period,
        surgery_case_id,
        total_charges,
        _updated_at
    from {{ ref('prep_surgery_transactions') }}

),

surgery_turnover as (

    select
        surgery_case_key,
        on_time_minutes,
        surgery_minutes
    from {{ ref('prep_surgery_turnover') }}

),

surgery_combined as (

    select
        surgery_transactions.fiscal_year,
        surgery_transactions.fiscal_year_period,
        count(surgery_transactions.surgery_case_id) as surgery_cases,
        sum(surgery_transactions.total_charges) as surgery_charges,
        sum(surgery_turnover.on_time_minutes) as on_time_minutes,
        sum(surgery_turnover.surgery_minutes) as surgery_minutes,
        max(surgery_transactions._updated_at) as _updated_at
    from surgery_transactions
    left join surgery_turnover
        on surgery_transactions.surgery_case_key = surgery_turnover.surgery_case_key
    group by
        surgery_transactions.fiscal_year,
        surgery_transactions.fiscal_year_period

),

surgery_metrics as (

    select
        fiscal_year,
        fiscal_year_period,
        sum(surgery_cases) as surgery_cases,
        sum(surgery_charges) / sum(surgery_cases) as charge_per_case,
        sum(surgery_minutes) / sum(surgery_cases) as minutes_per_case,
        avg(on_time_minutes) as avg_on_time_minutes,
        avg(surgery_minutes) as avg_surgery_minutes,
        max(_updated_at) as _updated_at
    from surgery_combined
    group by
        fiscal_year,
        fiscal_year_period

)

select
    {{ dbt_utils.generate_surrogate_key(['fiscal_year_period']) }} as surgery_performance_key,
    fiscal_year,
    fiscal_year_period,
    surgery_cases,
    charge_per_case,
    minutes_per_case,
    avg_on_time_minutes,
    avg_surgery_minutes,
    _updated_at
from surgery_metrics

{% if is_incremental() %}
where _updated_at > (select max(_updated_at) from {{ this }} )
{% endif %}
