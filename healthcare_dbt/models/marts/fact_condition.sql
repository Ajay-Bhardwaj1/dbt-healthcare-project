{{ config(materialized='table') }}

select
    c.PATIENT_ID,
    c.ENCOUNTER_ID,
    dp.PATIENT_KEY,
    c.START_DATE,
    c.STOP_DATE,
    c.CONDITION_CODE,
    c.CONDITION_DESCRIPTION

from {{ ref('psa_conditions') }} c
left join {{ ref('dim_patient') }} dp
    on c.PATIENT_ID = dp.PATIENT_ID
    and c.START_DATE >= dp.VALID_FROM
    and c.START_DATE < dp.VALID_TO