{{ config(materialized='table') }}

select
    e.ENCOUNTER_ID,
    dp.PATIENT_KEY,
    dpr.PROVIDER_KEY,
    do_.ORGANIZATION_KEY,
    dpy.PAYER_KEY,
    e.START_DATE,
    e.END_DATE,
    e.ENCOUNTER_CLASS,
    e.CODE_CODE as ENCOUNTER_CODE,
    e.ENCOUNTER_DESCRIPTION,
    e.BASE_ENCOUNTER_COST,
    e.TOTAL_CLAIM_COST,
    e.PAYER_COVERAGE,
    e.REASON_CODE,
    e.REASON_DESCRIPTION

from {{ ref('psa_encounters') }} e
left join {{ ref('dim_patient') }} dp
    on e.PATIENT_ID = dp.PATIENT_ID
    and e.START_DATE >= dp.VALID_FROM
    and e.START_DATE < dp.VALID_TO
left join {{ ref('dim_provider') }} dpr
    on e.PROVIDER_ID = dpr.PROVIDER_ID
    and e.START_DATE >= dpr.VALID_FROM
    and e.START_DATE < dpr.VALID_TO
left join {{ ref('dim_organization') }} do_
    on e.ORGANIZATION_ID = do_.ORGANIZATION_ID
    and e.START_DATE >= do_.VALID_FROM
    and e.START_DATE < do_.VALID_TO
left join {{ ref('dim_payer') }} dpy
    on e.PAYER_ID = dpy.PAYER_ID
    and e.START_DATE >= dpy.VALID_FROM
    and e.START_DATE < dpy.VALID_TO