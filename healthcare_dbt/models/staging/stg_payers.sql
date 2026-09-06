{{ config(materialized='table') }}
select
    "Id"                       as PAYER_ID,
    "NAME"                       as PAYER_NAME,
    "ADDRESS"                      as ADDRESS,
    "CITY"                           as CITY,
    "STATE_HEADQUARTERED"              as STATE_HEADQUARTERED,
    "ZIP"                                as ZIP,
    "PHONE"                                as PHONE,
    "AMOUNT_COVERED"::double                 as AMOUNT_COVERED,
    "AMOUNT_UNCOVERED"::double                 as AMOUNT_UNCOVERED,
    "REVENUE"::double                            as REVENUE,
    "COVERED_ENCOUNTERS"::integer                  as COVERED_ENCOUNTERS,
    "UNCOVERED_ENCOUNTERS"::integer                  as UNCOVERED_ENCOUNTERS,
    "COVERED_MEDICATIONS"::integer                     as COVERED_MEDICATIONS,
    "UNCOVERED_MEDICATIONS"::integer                     as UNCOVERED_MEDICATIONS,
    "COVERED_PROCEDURES"::integer                          as COVERED_PROCEDURES,
    "UNCOVERED_PROCEDURES"::integer                          as UNCOVERED_PROCEDURES,
    "COVERED_IMMUNIZATIONS"::integer                           as COVERED_IMMUNIZATIONS,
    "UNCOVERED_IMMUNIZATIONS"::integer                           as UNCOVERED_IMMUNIZATIONS,
    "UNIQUE_CUSTOMERS"::integer                                    as UNIQUE_CUSTOMERS,
    "QOLS_AVG"::double                                               as QOLS_AVG,
    "MEMBER_MONTHS"::integer                                          as MEMBER_MONTHS
from {{ source('source', 'payers') }}