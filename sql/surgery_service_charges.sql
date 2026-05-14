select
    fiscal_year,
    fiscal_year_period,
    entity_id,
    service_line,
    sum(total_charges) as total_charges
from healthcare.main_financial.surgery_transactions
where 
    case_status = 'COMPLETED'
    and fiscal_year_period = ?
group by
    fiscal_year,
    fiscal_year_period,
    entity_id,
    service_line
