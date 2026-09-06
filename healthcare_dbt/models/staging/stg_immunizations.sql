{{ config(materialized='table') }}
select
    "DATE"::timestamp  as IMMUNIZATION_DATETIME,
    "PATIENT"            as PATIENT_ID,
    "ENCOUNTER"            as ENCOUNTER_ID,
    "CODE"                  as IMMUNIZATION_CODE,
    "DESCRIPTION"             as IMMUNIZATION_DESCRIPTION,
    "BASE_COST"::double         as BASE_COST
from {{ source('source', 'immunizations') }}