{{ config(materialized='table') }}

select
    m.PATIENT_ID,
    m.ENCOUNTER_ID,
    dp.PATIENT_KEY,
    m.PAYER_ID,
    dpy.PAYER_KEY,
    m.START_DATETIME,
    m.STOP_DATETIME,
    m.MEDICATION_CODE,
    m.MEDICATION_DESCRIPTION,
    m.BASE_COST,
    m.PAYER_COVERAGE,
    m.DISPENSES,
    m.TOTAL_COST,
    m.REASON_CODE,
    m.REASON_DESCRIPTION

from {{ ref('psa_medications') }} m
left join {{ ref('dim_patient') }} dp
    on m.PATIENT_ID = dp.PATIENT_ID
    and cast(m.START_DATETIME as date) >= dp.VALID_FROM
    and cast(m.START_DATETIME as date) < dp.VALID_TO
left join {{ ref('dim_payer') }} dpy
    on m.PAYER_ID = dpy.PAYER_ID
    and cast(m.START_DATETIME as date) >= dpy.VALID_FROM
    and cast(m.START_DATETIME as date) < dpy.VALID_TO