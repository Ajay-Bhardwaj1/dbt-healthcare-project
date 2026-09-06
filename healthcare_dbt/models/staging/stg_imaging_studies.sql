{{ config(materialized='table') }}
select
    "Id"                     as IMAGING_STUDY_ID,
    "DATE"::timestamp          as STUDY_DATETIME,
    "PATIENT"                   as PATIENT_ID,
    "ENCOUNTER"                   as ENCOUNTER_ID,
    "SERIES_UID"                   as SERIES_UID,
    "BODYSITE_CODE"                  as BODYSITE_CODE,
    "BODYSITE_DESCRIPTION"             as BODYSITE_DESCRIPTION,
    "MODALITY_CODE"                      as MODALITY_CODE,
    "MODALITY_DESCRIPTION"                 as MODALITY_DESCRIPTION,
    "INSTANCE_UID"                           as INSTANCE_UID,
    "SOP_CODE"                                 as SOP_CODE,
    "SOP_DESCRIPTION"                            as SOP_DESCRIPTION,
    "PROCEDURE_CODE"                               as PROCEDURE_CODE
from {{ source('source', 'imaging_studies') }}