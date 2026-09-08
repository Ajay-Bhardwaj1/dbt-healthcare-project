{{ config(materialized='table') }}

select
    md5(concat_ws('|', PROVIDER_ID, cast(PSA_LOADED_AT as varchar))) as PROVIDER_KEY,
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
    PSA_LOADED_AT as VALID_FROM,
    coalesce(
        lead(PSA_LOADED_AT) over (partition by PROVIDER_ID order by PSA_LOADED_AT),
        cast('9999-12-31' as timestamp)
    ) as VALID_TO,
    case
        when lead(PSA_LOADED_AT) over (partition by PROVIDER_ID order by PSA_LOADED_AT) is null
        then true else false
    end as IS_CURRENT

from {{ ref('psa_providers') }}