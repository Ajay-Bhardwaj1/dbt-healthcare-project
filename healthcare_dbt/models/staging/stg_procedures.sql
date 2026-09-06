{{ config(materialized='table') }}
select
    "START"::timestamp  as START_DATETIME,
    "STOP"::timestamp     as STOP_DATETIME,
    "PATIENT"               as PATIENT_ID,
    "ENCOUNTER"               as ENCOUNTER_ID,
    "CODE"                      as PROCEDURE_CODE,
    "DESCRIPTION"                 as PROCEDURE_DESCRIPTION,
    "BASE_COST"::double             as BASE_COST,
    "REASONCODE"                      as REASON_CODE,
    "REASONDESCRIPTION"                 as REASON_DESCRIPTION
from {{ source('source', 'procedures') }}