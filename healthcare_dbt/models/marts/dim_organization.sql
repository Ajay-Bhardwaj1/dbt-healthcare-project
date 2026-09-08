{{ config(materialized='table') }}

select
    md5(concat_ws('|', ORGANIZATION_ID, cast(PSA_LOADED_AT as varchar))) as ORGANIZATION_KEY,
    ORGANIZATION_ID,
    ORGANIZATION_NAME,
    ADDRESS,
    CITY,
    STATE,
    ZIP,
    LATITUDE,
    LONGITUDE,
    PHONE,
    REVENUE,
    UTILIZATION,
    PSA_LOADED_AT as VALID_FROM,
    coalesce(
        lead(PSA_LOADED_AT) over (partition by ORGANIZATION_ID order by PSA_LOADED_AT),
        cast('9999-12-31' as timestamp)
    ) as VALID_TO,
    case
        when lead(PSA_LOADED_AT) over (partition by ORGANIZATION_ID order by PSA_LOADED_AT) is null
        then true else false
    end as IS_CURRENT

from {{ ref('psa_organizations') }}