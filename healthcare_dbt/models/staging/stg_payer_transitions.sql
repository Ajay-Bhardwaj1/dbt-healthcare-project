{{ config(materialized='table') }}
select
    "PATIENT"           as PATIENT_ID,
    "MEMBERID"            as MEMBER_ID,
    "START_YEAR"::integer   as START_YEAR,
    "END_YEAR"::integer       as END_YEAR,
    "PAYER"                     as PAYER_ID,
    "SECONDARY_PAYER"             as SECONDARY_PAYER_ID,
    "OWNERSHIP"                     as OWNERSHIP,
    "OWNERNAME"                       as OWNER_NAME
from {{ source('source', 'payer_transitions') }}