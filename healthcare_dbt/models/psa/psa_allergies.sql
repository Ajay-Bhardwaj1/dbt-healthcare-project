{{ config(materialized='incremental') }}

select
    START_DATE,
    STOP_DATE,
    PATIENT_ID,
    ENCOUNTER_ID,
    ALLERGY_CODE,
    CODE_SYSTEM,
    ALLERGY_DESCRIPTION,
    ALLERGY_TYPE,
    ALLERGY_CATEGORY,
    REACTION_1,
    REACTION_1_DESCRIPTION,
    SEVERITY_1,
    REACTION_2,
    REACTION_2_DESCRIPTION,
    SEVERITY_2
from {{ ref('stg_allergies') }}

{% if is_incremental() %}
where concat_ws('|', PATIENT_ID, ENCOUNTER_ID, ALLERGY_CODE)
not in (select concat_ws('|', PATIENT_ID, ENCOUNTER_ID, ALLERGY_CODE) from {{ this }})
{% endif %}