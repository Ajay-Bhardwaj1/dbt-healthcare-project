{{ config(materialized='incremental') }}

select
    ENCOUNTER_ID,
    START_DATE,
    END_DATE,
    PATIENT_ID,
    ORGANIZATION_ID,
    PROVIDER_ID,
    PAYER_ID,
    ENCOUNTER_CLASS,
    CODE_CODE,
    ENCOUNTER_DESCRIPTION,
    BASE_ENCOUNTER_COST,
    TOTAL_CLAIM_COST,
    PAYER_COVERAGE,
    REASON_CODE,
    REASON_DESCRIPTION
from {{ ref('stg_encounters') }}
{% if is_incremental() %}
where ENCOUNTER_ID not in (select ENCOUNTER_ID from {{ this }})
{% endif %}