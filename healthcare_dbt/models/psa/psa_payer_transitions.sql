{{ config(materialized='incremental') }}

select
    PATIENT_ID,
    MEMBER_ID,
    START_YEAR,
    END_YEAR,
    PAYER_ID,
    SECONDARY_PAYER_ID,
    OWNERSHIP,
    OWNER_NAME
from {{ ref('stg_payer_transitions') }}

{% if is_incremental() %}
where concat_ws('|', PATIENT_ID, PAYER_ID, cast(START_YEAR as varchar))
not in (select concat_ws('|', PATIENT_ID, PAYER_ID, cast(START_YEAR as varchar)) from {{ this }})
{% endif %}