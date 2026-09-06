{{ config(materialized='table') }}
select
    "DATE"::date  as SUPPLY_DATE,
    "PATIENT"       as PATIENT_ID,
    "ENCOUNTER"       as ENCOUNTER_ID,
    "CODE"              as SUPPLY_CODE,
    "DESCRIPTION"         as SUPPLY_DESCRIPTION,
    "QUANTITY"::integer     as QUANTITY
from {{ source('source', 'supplies') }}