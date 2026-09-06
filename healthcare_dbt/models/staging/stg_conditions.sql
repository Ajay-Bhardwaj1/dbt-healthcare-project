{{ config(materialized='table') }}
select
    "START"::date  as START_DATE,
    "STOP"::date    as STOP_DATE,
    "PATIENT"        as PATIENT_ID,
    "ENCOUNTER"       as ENCOUNTER_ID,
    "CODE"             as CONDITION_CODE,
    "DESCRIPTION"       as CONDITION_DESCRIPTION
from {{ source('source', 'conditions') }}