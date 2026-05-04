{{
    config(
        materialized='incremental',
        unique_key='provider_revenue_key'
    )
}}

with

prep_provider_revenue as (

    select
        provider_revenue_key,
        fiscal_year,
        fiscal_year_period,
        provider_department,
        provider_specialty,
        billed_units,
        total_charges,
        _updated_at
    from {{ ref('prep_provider_revenue') }}

)

select
    provider_revenue_key,
    fiscal_year,
    fiscal_year_period,
    provider_department,
    provider_specialty,
    billed_units,
    total_charges,
    _updated_at
from prep_provider_revenue

{% if is_incremental() %}
where _updated_at > (select max(_updated_at) from {{ this }} )
{% endif %}
