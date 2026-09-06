{{ config(materialized = 'incremental') }}

SELECT
    ORGANIZATION_ID,
    ORGANIZATION_NAME,
    ADDRESS,
    CITY,
    upper(trim(STATE)) as STATE,
    ZIP,
    LATITUDE,
    LONGITUDE,
    PHONE,
    REVENUE,
    UTILIZATION,
    MD5(
        CONCAT_WS('|',
        COALESCE(CAST(ORGANIZATION_NAME AS VARCHAR), ''),
        COALESCE(ADDRESS, ''),
        COALESCE(CITY, ''),
        COALESCE(UPPER(TRIM(STATE)), ''),
        COALESCE(ZIP, ''),
        COALESCE(CAST(LATITUDE AS VARCHAR), ''),
        COALESCE(CAST(LONGITUDE AS VARCHAR), ''),
        COALESCE(PHONE, ''),
        COALESCE(CAST(REVENUE AS VARCHAR), ''),
        COALESCE(CAST(UTILIZATION AS VARCHAR), '')
    )) AS ROW_HASH,
    CURRENT_TIMESTAMP AS PSA_LOADED_AT
FROM {{ ref('stg_organizations') }}
{% if is_incremental() %}
WHERE MD5(
        CONCAT_WS('|',
        COALESCE(CAST(ORGANIZATION_NAME AS VARCHAR), ''),
        COALESCE(ADDRESS, ''),
        COALESCE(CITY, ''),
        COALESCE(UPPER(TRIM(STATE)), ''),
        COALESCE(ZIP, ''),
        COALESCE(CAST(LATITUDE AS VARCHAR), ''),
        COALESCE(CAST(LONGITUDE AS VARCHAR), ''),
        COALESCE(PHONE, ''),
        COALESCE(CAST(REVENUE AS VARCHAR), ''),
        COALESCE(CAST(UTILIZATION AS VARCHAR), '')
    )) NOT IN (SELECT ROW_HASH FROM {{ this }})
{% endif %}