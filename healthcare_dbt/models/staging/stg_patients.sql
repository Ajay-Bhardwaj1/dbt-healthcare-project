{{ config(materialized='table') }}

select
    "Id"                     as patient_id,
    "BIRTHDATE"::date        as birth_date,
    "DEATHDATE"::date        as death_date,
    "SSN"                    as ssn,
    "DRIVERS"                as drivers_license,
    "PASSPORT"                as passport,
    "PREFIX"                 as name_prefix,
    "FIRST"                  as first_name,
    "LAST"                   as last_name,
    "SUFFIX"                 as name_suffix,
    "MAIDEN"                 as maiden_name,
    "MARITAL"                as marital_status,
    "RACE"                   as race,
    "ETHNICITY"              as ethnicity,
    "GENDER"                 as gender,
    "BIRTHPLACE"             as birthplace,
    "ADDRESS"                as address,
    "CITY"                   as city,
    "STATE"                  as state,
    "COUNTY"                 as county,
    "ZIP"                    as zip,
    "LAT"::double             as latitude,
    "LON"::double             as longitude,
    "HEALTHCARE_EXPENSES"::double as healthcare_expenses,
    "HEALTHCARE_COVERAGE"::double as healthcare_coverage
from {{ source('source', 'patients') }}