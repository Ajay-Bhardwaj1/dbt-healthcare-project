{{ config(materialized='incremental') }}

select
    IMMUNIZATION_DATETIME,
    PATIENT_ID,
    ENCOUNTER_ID,
    IMMUNIZATION_CODE,
    IMMUNIZATION_DESCRIPTION,
    BASE_COST
from {{ ref('stg_immunizations') }}

{% if is_incremental() %}
where concat_ws('|', PATIENT_ID, ENCOUNTER_ID, IMMUNIZATION_CODE, cast(IMMUNIZATION_DATETIME as varchar))
not in (select concat_ws('|', PATIENT_ID, ENCOUNTER_ID, IMMUNIZATION_CODE, cast(IMMUNIZATION_DATETIME as varchar)) from {{ this }})
{% endif %}