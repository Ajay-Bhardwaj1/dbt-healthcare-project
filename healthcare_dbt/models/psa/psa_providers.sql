{{ config(materialized='incremental') }}

select
    PROVIDER_ID,
    ORGANIZATION_ID,
    PROVIDER_NAME,
    GENDER,
    SPECIALITY,
    ADDRESS,
    CITY,
    STATE,
    ZIP,
    LATITUDE,
    LONGITUDE,
    UTILIZATION,
    MD5(CONCAT_WS('|',
        COALESCE(ORGANIZATION_ID, ''),
        COALESCE(PROVIDER_NAME, ''),
        COALESCE(UPPER(TRIM(GENDER)), ''),
        COALESCE(UPPER(TRIM(SPECIALITY)), ''),
        COALESCE(ADDRESS, ''),
        COALESCE(CITY, ''),
        COALESCE(UPPER(TRIM(STATE)), ''),
        COALESCE(ZIP, ''),
        COALESCE(CAST(LATITUDE AS VARCHAR), ''),
        COALESCE(CAST(LONGITUDE AS VARCHAR), ''),
        COALESCE(CAST(UTILIZATION AS VARCHAR), '')
    )) AS ROW_HASH,
    current_timestamp as PSA_LOADED_AT
from {{ ref('stg_providers') }}

{% if is_incremental() %}
where MD5(CONCAT_WS('|',
        COALESCE(ORGANIZATION_ID, ''),
        COALESCE(PROVIDER_NAME, ''),
        COALESCE(UPPER(TRIM(GENDER)), ''),
        COALESCE(UPPER(TRIM(SPECIALITY)), ''),
        COALESCE(ADDRESS, ''),
        COALESCE(CITY, ''),
        COALESCE(UPPER(TRIM(STATE)), ''),
        COALESCE(ZIP, ''),
        COALESCE(CAST(LATITUDE AS VARCHAR), ''),
        COALESCE(CAST(LONGITUDE AS VARCHAR), ''),
        COALESCE(CAST(UTILIZATION AS VARCHAR), '')
    )) not in(select ROW_HASH from {{this}})
{% endif %}