{{config(MATERIALIZED = 'table')}}

SELECT
    
    "Id"                            as ENCOUNTER_ID,
    "START"::date                   as START_DATE,
    "STOP"::date                    as END_DATE,
    'PATIENT'                       as PATIENT_ID,
    "ORGANIZATION"                  as ORGANIZATION_ID,
    "PROVIDER"                      as PROVIDER_ID,
    "PAYER"                         as  PAYER_ID,
    "ENCOUNTERCLASS"                as  ENCOUNTER_CLASS,
    "CODE"                          as  CODE_CODE,
    "DESCRIPTION"                   as  ENCOUNTER_DESCRIPTION,
    "BASE_ENCOUNTER_COST"::double   as BASE_ENCOUNTER_COST, 
    "TOTAL_CLAIM_COST" ::double     as  TOTAL_CLAIM_COST,
    "PAYER_COVERAGE"::double        as  PAYER_COVERAGE,
    "REASONCODE"                    as  REASON_CODE,
    "REASONDESCRIPTION"             as   REASON_DESCRIPTION
from {{source('source','encounters')}}