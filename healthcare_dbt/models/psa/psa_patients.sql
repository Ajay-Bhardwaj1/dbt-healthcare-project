{{ config(materialized='incremental') }}

select
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
    upper(trim(MARITAL_STATUS))   as MARITAL_STATUS,
    upper(trim(RACE))             as RACE,
    upper(trim(ETHNICITY))        as ETHNICITY,
    upper(trim(GENDER))           as GENDER,
    BIRTHPLACE,
    ADDRESS,
    CITY,
    upper(trim(STATE))            as STATE,
    COUNTY,
    ZIP,
    LATITUDE,
    LONGITUDE,
    HEALTHCARE_EXPENSES,
    HEALTHCARE_COVERAGE,
    case when DEATH_DATE is not null then true else false end as IS_DECEASED,
    md5(concat_ws('|',
        coalesce(cast(BIRTH_DATE as varchar), ''),
        coalesce(cast(DEATH_DATE as varchar), ''),
        coalesce(upper(trim(MARITAL_STATUS)), ''),
        coalesce(upper(trim(RACE)), ''),
        coalesce(upper(trim(ETHNICITY)), ''),
        coalesce(upper(trim(GENDER)), ''),
        coalesce(ADDRESS, ''),
        coalesce(CITY, ''),
        coalesce(upper(trim(STATE)), ''),
        coalesce(ZIP, '')
    )) as ROW_HASH,
    current_timestamp as PSA_LOADED_AT

from {{ ref('stg_patients') }}

{% if is_incremental() %}
where md5(concat_ws('|',
        coalesce(cast(BIRTH_DATE as varchar), ''),
        coalesce(cast(DEATH_DATE as varchar), ''),
        coalesce(upper(trim(MARITAL_STATUS)), ''),
        coalesce(upper(trim(RACE)), ''),
        coalesce(upper(trim(ETHNICITY)), ''),
        coalesce(upper(trim(GENDER)), ''),
        coalesce(ADDRESS, ''),
        coalesce(CITY, ''),
        coalesce(upper(trim(STATE)), ''),
        coalesce(ZIP, '')
    )) not in (select ROW_HASH from {{ this }})
{% endif %}