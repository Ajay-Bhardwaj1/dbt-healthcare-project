{{ config(materialized='table') }}

select
    p.PATIENT_ID,
    p.ENCOUNTER_ID,
    dp.PATIENT_KEY,
    p.START_DATETIME,
    p.STOP_DATETIME,
    p.PROCEDURE_CODE,
    p.PROCEDURE_DESCRIPTION,
    p.BASE_COST,
    p.REASON_CODE,
    p.REASON_DESCRIPTION

from {{ ref('psa_procedures') }} p
left join {{ ref('dim_patient') }} dp
    on p.PATIENT_ID = dp.PATIENT_ID
    and cast(p.START_DATETIME as date) >= dp.VALID_FROM
    and cast(p.START_DATETIME as date) < dp.VALID_TO