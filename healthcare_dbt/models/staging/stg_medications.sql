{{ config(materialized='table') }}
select
    "START"::timestamp     as START_DATETIME,
    "STOP"::timestamp        as STOP_DATETIME,
    "PATIENT"                  as PATIENT_ID,
    "PAYER"                      as PAYER_ID,
    "ENCOUNTER"                    as ENCOUNTER_ID,
    "CODE"                           as MEDICATION_CODE,
    "DESCRIPTION"                      as MEDICATION_DESCRIPTION,
    "BASE_COST"::double                 as BASE_COST,
    "PAYER_COVERAGE"::double              as PAYER_COVERAGE,
    "DISPENSES"::integer                    as DISPENSES,
    "TOTALCOST"::double                       as TOTAL_COST,
    "REASONCODE"                                as REASON_CODE,
    "REASONDESCRIPTION"                           as REASON_DESCRIPTION
from {{ source('source', 'medications') }}