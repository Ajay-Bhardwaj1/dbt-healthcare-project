{{ config(materialized='incremental') }}

select
    SUPPLY_DATE,
    PATIENT_ID,
    ENCOUNTER_ID,
    SUPPLY_CODE,
    SUPPLY_DESCRIPTION,
    QUANTITY
from {{ ref('stg_supplies') }}

{% if is_incremental() %}
where concat_ws('|', PATIENT_ID, ENCOUNTER_ID, SUPPLY_CODE)
not in (select concat_ws('|', PATIENT_ID, ENCOUNTER_ID, SUPPLY_CODE) from {{ this }})
{% endif %}