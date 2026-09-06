{{ config(materialized='table') }}
select
    "START"::date        as START_DATE,
    "STOP"::date          as STOP_DATE,
    "PATIENT"             as PATIENT_ID,
    "ENCOUNTER"            as ENCOUNTER_ID,
    "CODE"                 as ALLERGY_CODE,
    "SYSTEM"               as CODE_SYSTEM,
    "DESCRIPTION"          as ALLERGY_DESCRIPTION,
    "TYPE"                 as ALLERGY_TYPE,
    "CATEGORY"              as ALLERGY_CATEGORY,
    "REACTION1"             as REACTION_1,
    "DESCRIPTION1"          as REACTION_1_DESCRIPTION,
    "SEVERITY1"             as SEVERITY_1,
    "REACTION2"             as REACTION_2,
    "DESCRIPTION2"          as REACTION_2_DESCRIPTION,
    "SEVERITY2"             as SEVERITY_2
from {{ source('source', 'allergies') }}