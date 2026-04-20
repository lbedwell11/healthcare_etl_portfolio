with

fact_claims as (

    select
        claim_id,
        fiscal_year_period,
        mrn,
        hospital_account_id,
        entity_id,
        service_date,
        posted_date,
        billed_amount,
        paid_amount,
        claim_status,
        _updated_at
    from {{ ref('fact_claims') }}

),

entity_aggregations as (

    select
        entity_id,
        fiscal_year_period,
        count(*) as total_claims,
        sum(billed_amount) as total_billed_amount,
        sum(paid_amount) as total_paid_amount,
        sum(
            case
                when claim_status = 'DENIED' then 1 
                else 0 
            end) as total_denied_claims
    from fact_claims
    group by
        entity_id,
        fiscal_year_period,

),

performance_transformed as (

    select
        entity_id,
        fiscal_year_period,
        total_claims,
        total_billed_amount,
        total_paid_amount,
        total_denied_claims,
        case
            when total_denied_claims = 0 then 0
            else total_denied_claims / total_claims
        end as denial_rate,
        case
            when total_paid_amount = 0 then 0
            else total_paid_amount / total_billed_amount
        end as payment_percentage
    from entity_aggregations

)

select
    {{ dbt_utils.generate_surrogate_key ([
        'fiscal_year_period',
        'entity_id'
    ]) }} as metrics_entity_performance_key,
    fiscal_year_period,
    entity_id,
    total_claims,
    total_billed_amount,
    total_paid_amount,
    total_denied_claims,
    denial_rate,
    payment_percentage
from performance_transformed
