{{ config(materialized='incremental') }}

select
    OBSERVATION_DATETIME,
    PATIENT_ID,
    ENCOUNTER_ID,
    OBSERVATION_CATEGORY,
    OBSERVATION_CODE,
    OBSERVATION_DESCRIPTION,
    OBSERVATION_VALUE,
    OBSERVATION_UNITS,
    VALUE_TYPE
from {{ ref('stg_observations') }}

{% if is_incremental() %}
where concat_ws('|', PATIENT_ID, ENCOUNTER_ID, OBSERVATION_CODE, cast(OBSERVATION_DATETIME as varchar))
not in (select concat_ws('|', PATIENT_ID, ENCOUNTER_ID, OBSERVATION_CODE, cast(OBSERVATION_DATETIME as varchar)) from {{ this }})
{% endif %}