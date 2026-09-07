{{ config(materialized='incremental') }}

select
    START_DATETIME,
    STOP_DATETIME,
    PATIENT_ID,
    PAYER_ID,
    ENCOUNTER_ID,
    MEDICATION_CODE,
    MEDICATION_DESCRIPTION,
    BASE_COST,
    PAYER_COVERAGE,
    DISPENSES,
    TOTAL_COST,
    REASON_CODE,
    REASON_DESCRIPTION
from {{ ref('stg_medications') }}
{% if is_incremental() %}
where concat_ws('|',PATIENT_ID,ENCOUNTER_ID,MEDICATION_CODE)
not in (select concat_ws('|',PATIENT_ID,ENCOUNTER_ID,MEDICATION_CODE) from {{ this }})
{% endif %}