{{ config(materialized='table') }}
select
    "Id"                as CAREPLAN_ID,
    "START"::date        as START_DATE,
    "STOP"::date          as STOP_DATE,
    "PATIENT"             as PATIENT_ID,
    "ENCOUNTER"            as ENCOUNTER_ID,
    "CODE"                 as CAREPLAN_CODE,
    "DESCRIPTION"          as CAREPLAN_DESCRIPTION,
    "REASONCODE"            as REASON_CODE,
    "REASONDESCRIPTION"     as REASON_DESCRIPTION
from {{ source('source', 'careplans') }}