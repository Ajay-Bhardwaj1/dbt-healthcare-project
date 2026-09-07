{{ config(materialized='incremental') }}

select
    START_DATETIME,
    STOP_DATETIME,
    PATIENT_ID,
    ENCOUNTER_ID,
    DEVICE_CODE,
    DEVICE_DESCRIPTION,
    UDI
from {{ ref('stg_devices') }}

{% if is_incremental() %}
where UDI not in (select UDI from {{ this }})
{% endif %}