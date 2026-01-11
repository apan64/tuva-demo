select
    -- IDs
    claim_id,
    claim_line_number,
    person_id,
    
    -- Demographics / Categories
    claim_type,
    place_of_service_code,
    bill_type_code,
    
    -- Financials
    paid_amount,
    total_cost_amount,
    
    -- Diagnoses
    diagnosis_code_type,
    diagnosis_code_1,
    diagnosis_code_2,
    diagnosis_code_3,
    diagnosis_code_4,
    diagnosis_code_5,
    diagnosis_code_6,
    diagnosis_code_7,
    diagnosis_code_8,
    diagnosis_code_9,
    diagnosis_code_10,
    diagnosis_code_11,
    diagnosis_code_12,
    diagnosis_code_13,
    diagnosis_code_14,
    diagnosis_code_15,
    diagnosis_code_16,
    diagnosis_code_17,
    diagnosis_code_18,
    diagnosis_code_19,
    diagnosis_code_20,
    diagnosis_code_21,
    diagnosis_code_22,
    diagnosis_code_23,
    diagnosis_code_24,
    diagnosis_code_25,
    
    -- Dates
    claim_start_date,
    claim_end_date

from {{ ref('medical_claim') }}
