{{ config(materialized='incremental') }}

select
    TRANSACTION_ID,
    CLAIM_ID,
    CHARGE_ID,
    PATIENT_ID,
    TRANSACTION_TYPE,
    AMOUNT,
    METHOD,
    FROM_DATE,
    TO_DATE,
    PLACE_OF_SERVICE,
    PROCEDURE_CODE,
    MODIFIER_1,
    MODIFIER_2,
    DIAGNOSIS_REF_1,
    DIAGNOSIS_REF_2,
    DIAGNOSIS_REF_3,
    DIAGNOSIS_REF_4,
    UNITS,
    DEPARTMENT_ID,
    NOTES,
    UNIT_AMOUNT,
    TRANSFER_OUT_ID,
    TRANSFER_TYPE,
    PAYMENTS,
    ADJUSTMENTS,
    TRANSFERS,
    OUTSTANDING,
    APPOINTMENT_ID,
    LINE_NOTE,
    PATIENT_INSURANCE_ID,
    FEE_SCHEDULE_ID,
    PROVIDER_ID,
    SUPERVISING_PROVIDER_ID
from {{ ref('stg_claims_transactions') }}

{% if is_incremental() %}
where TRANSACTION_ID not in (select TRANSACTION_ID from {{ this }})
{% endif %}