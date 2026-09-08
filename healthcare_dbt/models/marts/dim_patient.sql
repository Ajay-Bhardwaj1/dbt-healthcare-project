{{ config(materialized='table') }}

select
    md5(concat_ws('|', PATIENT_ID, cast(PSA_LOADED_AT as varchar))) as PATIENT_KEY,
    PATIENT_ID,
    BIRTH_DATE,
    DEATH_DATE,
    SSN,
    DRIVERS_LICENSE,
    PASSPORT,
    NAME_PREFIX,
    FIRST_NAME,
    LAST_NAME,
    NAME_SUFFIX,
    MAIDEN_NAME,
    MARITAL_STATUS,
    RACE,
    ETHNICITY,
    GENDER,
    BIRTHPLACE,
    ADDRESS,
    CITY,
    STATE,
    COUNTY,
    ZIP,
    LATITUDE,
    LONGITUDE,
    HEALTHCARE_EXPENSES,
    HEALTHCARE_COVERAGE,
    IS_DECEASED,
    PSA_LOADED_AT as VALID_FROM,
    coalesce(
        lead(PSA_LOADED_AT) over (partition by PATIENT_ID order by PSA_LOADED_AT),
        cast('9999-12-31' as timestamp)
    ) as VALID_TO,
    case
        when lead(PSA_LOADED_AT) over (partition by PATIENT_ID order by PSA_LOADED_AT) is null
        then true else false
    end as IS_CURRENT

from {{ ref('psa_patients') }}