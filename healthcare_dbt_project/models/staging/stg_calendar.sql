with

source as (

    select
        cast(calendar_date as date) as calendar_date,
        cast(fiscal_year as varchar) as fiscal_year,
        cast(fiscal_month as varchar) as fiscal_month,
        cast(fiscal_year_period as varchar) as fiscal_year_period
    from {{ source('seeds', 'calendar') }}

)

select
    calendar_date,
    fiscal_year,
    fiscal_month,
    fiscal_year_period
from source
