{{ config(materialized='incremental') }}

SELECT  
    START_DATETIME,
    STOP_DATETIME,
    PATIENT_ID,
    ENCOUNTER_ID,
    PROCEDURE_CODE,
    PROCEDURE_DESCRIPTION,
    BASE_COST,
    REASON_CODE,
    REASON_DESCRIPTION
from{{ ref('stg_procedures') }}
{% if is_incremental() %}
where concat_ws('|',PATIENT_ID, ENCOUNTER_ID, PROCEDURE_CODE)
not in (select concat_ws('|',PATIENT_ID, ENCOUNTER_ID, PROCEDURE_CODE) from {{ this }})
{% endif %}