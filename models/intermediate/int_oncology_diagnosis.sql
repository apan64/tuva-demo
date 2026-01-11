with unpivoted as (
    {% for i in range(1, 26) %}
    select 
        person_id, 
        diagnosis_code_{{ i }} as diagnosis_code 
    from {{ ref('stg_medical_claim') }}
    where diagnosis_code_{{ i }} is not null
    {% if not loop.last %} union all {% endif %}
    {% endfor %}
),

cancer_codes as (
    select distinct
        person_id,
        diagnosis_code,
        left(diagnosis_code, 3) as cancer_type_code
    from unpivoted
    where diagnosis_code like 'C%'
)

select distinct
    person_id,
    cancer_type_code
from cancer_codes
