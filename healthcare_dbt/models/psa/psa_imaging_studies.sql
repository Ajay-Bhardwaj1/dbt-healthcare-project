{{ config(materialized='incremental') }}

select
    IMAGING_STUDY_ID,
    STUDY_DATETIME,
    PATIENT_ID,
    ENCOUNTER_ID,
    SERIES_UID,
    BODYSITE_CODE,
    BODYSITE_DESCRIPTION,
    MODALITY_CODE,
    MODALITY_DESCRIPTION,
    INSTANCE_UID,
    SOP_CODE,
    SOP_DESCRIPTION,
    PROCEDURE_CODE
from {{ ref('stg_imaging_studies') }}

{% if is_incremental() %}
where IMAGING_STUDY_ID not in (select IMAGING_STUDY_ID from {{ this }})
{% endif %}