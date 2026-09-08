{{ config(materialized='table') }}

select
    md5(concat_ws('|', PAYER_ID, cast(PSA_LOADED_AT as varchar))) as PAYER_KEY,
    PAYER_ID,
    PAYER_NAME,
    ADDRESS,
    CITY,
    STATE_HEADQUARTERED,
    ZIP,
    PHONE,
    AMOUNT_COVERED,
    AMOUNT_UNCOVERED,
    REVENUE,
    COVERED_ENCOUNTERS,
    UNCOVERED_ENCOUNTERS,
    COVERED_MEDICATIONS,
    UNCOVERED_MEDICATIONS,
    COVERED_PROCEDURES,
    UNCOVERED_PROCEDURES,
    COVERED_IMMUNIZATIONS,
    UNCOVERED_IMMUNIZATIONS,
    UNIQUE_CUSTOMERS,
    QOLS_AVG,
    MEMBER_MONTHS,
    PSA_LOADED_AT as VALID_FROM,
    coalesce(
        lead(PSA_LOADED_AT) over (partition by PAYER_ID order by PSA_LOADED_AT),
        cast('9999-12-31' as timestamp)
    ) as VALID_TO,
    case
        when lead(PSA_LOADED_AT) over (partition by PAYER_ID order by PSA_LOADED_AT) is null
        then true else false
    end as IS_CURRENT

from {{ ref('psa_payers') }}