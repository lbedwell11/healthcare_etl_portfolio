/*
metrics:
    - case volume -- count of surgery cases --> surgery_cases
    - revenue per surgery -- sum(charges)/sum(surgery_cases)
    - avg on-time surgery start / "start-time threshold" -- sum()
*/


select
    surgery_performance_key,
    fiscal_year,
    fiscal_year_period,
    surgery_cases,
    charge_per_case,
    minutes_per_case,
    avg_on_time_minutes,
    avg_surgery_minutes,
    _updated_at
from {{ ref('int_surgery_performance') }}
