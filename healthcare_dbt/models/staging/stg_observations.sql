{{ config(materialized='table') }}
select
    "DATE"::timestamp  as OBSERVATION_DATETIME,
    "PATIENT"            as PATIENT_ID,
    "ENCOUNTER"            as ENCOUNTER_ID,
    "CATEGORY"               as OBSERVATION_CATEGORY,
    "CODE"                     as OBSERVATION_CODE,
    "DESCRIPTION"                as OBSERVATION_DESCRIPTION,
    "VALUE"                        as OBSERVATION_VALUE,
    "UNITS"                          as OBSERVATION_UNITS,
    "TYPE"                             as VALUE_TYPE
from {{ source('source', 'observations') }}