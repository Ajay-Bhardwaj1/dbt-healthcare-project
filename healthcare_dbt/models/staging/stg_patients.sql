{{ config(materialized='table') }}

select
    "Id"                          as PATIENT_ID,
    "BIRTHDATE"::date             as BIRTH_DATE,
    "DEATHDATE"::date             as DEATH_DATE,
    "SSN"                         as SSN,
    "DRIVERS"                     as DRIVERS_LICENSE,
    "PASSPORT"                    as PASSPORT,
    "PREFIX"                      as NAME_PREFIX,
    "FIRST"                       as FIRST_NAME,
    "LAST"                        as LAST_NAME,
    "SUFFIX"                      as NAME_SUFFIX,
    "MAIDEN"                      as MAIDEN_NAME,
    "MARITAL"                     as MARITAL_STATUS,
    "RACE"                        as RACE,
    "ETHNICITY"                   as ETHNICITY,
    "GENDER"                      as GENDER,
    "BIRTHPLACE"                  as BIRTHPLACE,
    "ADDRESS"                     as ADDRESS,
    "CITY"                        as CITY,
    "STATE"                       as STATE,
    "COUNTY"                      as COUNTY,
    "ZIP"                         as ZIP,
    "LAT"::double                 as LATITUDE,
    "LON"::double                 as LONGITUDE,
    "HEALTHCARE_EXPENSES"::double as HEALTHCARE_EXPENSES,
    "HEALTHCARE_COVERAGE"::double as HEALTHCARE_COVERAGE
from {{ source('source', 'patients') }}