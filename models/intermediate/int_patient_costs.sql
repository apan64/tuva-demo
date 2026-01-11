select
    person_id,
    case
        -- Professional / Has POS
        when place_of_service_code = '21' then 'Inpatient'
        when place_of_service_code = '23' then 'ER'
        when place_of_service_code in ('11', '19', '22', '24') then 'Outpatient'
        
        -- Institutional / Missing POS (Fall back to bill_type)
        -- Inpatient Hospital (11x, 12x) or SNF (2xx)
        when bill_type_code like '11%' or bill_type_code like '12%' or bill_type_code like '2%' then 'Inpatient'
        -- Outpatient Hospital (13x, 14x), Home Health (3xx), Clinic (7xx), Special (8xx)
        when bill_type_code like '13%' or bill_type_code like '14%' or bill_type_code like '3%' or bill_type_code like '7%' or bill_type_code like '8%' then 'Outpatient'
        
        else 'Other'
    end as care_setting,
    sum(coalesce(paid_amount, 0)) as total_paid
from {{ ref('stg_medical_claim') }}
group by 1, 2
