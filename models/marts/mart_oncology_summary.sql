with cancer_patients as (
    select
        person_id,
        -- Naive approach: take the min cancer code as primary label
        min(cancer_type_code) as primary_cancer_type,
        count(distinct cancer_type_code) as num_cancer_types
    from {{ ref('int_oncology_diagnosis') }}
    group by 1
),

costs as (
    select
        person_id,
        sum(total_paid) as total_paid,
        sum(case when care_setting = 'Inpatient' then total_paid else 0 end) as inpatient_paid,
        sum(case when care_setting = 'Outpatient' then total_paid else 0 end) as outpatient_paid,
        sum(case when care_setting = 'ER' then total_paid else 0 end) as er_paid,
        sum(case when care_setting = 'Other' then total_paid else 0 end) as other_paid
    from {{ ref('int_patient_costs') }}
    group by 1
)

select
    cp.person_id,
    cp.primary_cancer_type,
    cp.num_cancer_types,
    coalesce(c.total_paid, 0) as total_paid,
    coalesce(c.inpatient_paid, 0) as inpatient_paid,
    coalesce(c.outpatient_paid, 0) as outpatient_paid,
    coalesce(c.er_paid, 0) as er_paid,
    coalesce(c.other_paid, 0) as other_paid,
    
    -- Spend Buckets
    case
        when coalesce(c.total_paid, 0) > 100000 then 'High (>100k)'
        when coalesce(c.total_paid, 0) > 10000 then 'Medium (10k-100k)'
        else 'Low (<10k)'
    end as spend_bucket

from cancer_patients cp
left join costs c on cp.person_id = c.person_id
