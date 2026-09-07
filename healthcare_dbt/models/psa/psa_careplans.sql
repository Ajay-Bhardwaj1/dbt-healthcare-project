{{ config(materialized='incremental') }}

select
    CAREPLAN_ID,
    START_DATE,
    STOP_DATE,
    PATIENT_ID,
    ENCOUNTER_ID,
    CAREPLAN_CODE,
    CAREPLAN_DESCRIPTION,
    REASON_CODE,
    REASON_DESCRIPTION
from {{ ref('stg_careplans') }}

{% if is_incremental() %}
where CAREPLAN_ID not in (select CAREPLAN_ID from {{ this }})
{% endif %}