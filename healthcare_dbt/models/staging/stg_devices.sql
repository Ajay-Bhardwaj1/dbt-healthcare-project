{{ config(materialized='table') }}
select
    "START"::timestamp  as START_DATETIME,
    "STOP"::timestamp     as STOP_DATETIME,
    "PATIENT"              as PATIENT_ID,
    "ENCOUNTER"              as ENCOUNTER_ID,
    "CODE"                    as DEVICE_CODE,
    "DESCRIPTION"              as DEVICE_DESCRIPTION,
    "UDI"                       as UDI
from {{ source('source', 'devices') }}