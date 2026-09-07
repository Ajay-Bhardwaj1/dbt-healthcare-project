{{ config(materialized='incremental') }}

select
    START_DATE,
    STOP_DATE,
    PATIENT_ID,
    ENCOUNTER_ID,
    CONDITION_CODE,
    CONDITION_DESCRIPTION
from {{ ref('stg_conditions') }}

{% if is_incremental() %}
where concat_ws('|', PATIENT_ID, ENCOUNTER_ID, CONDITION_CODE) 
    not in (select concat_ws('|', PATIENT_ID, ENCOUNTER_ID, CONDITION_CODE) from {{ this }})
{% endif %}