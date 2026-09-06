{{ config(materialized='table') }}
select
    "Id"                as PROVIDER_ID,
    "ORGANIZATION"         as ORGANIZATION_ID,
    "NAME"                   as PROVIDER_NAME,
    "GENDER"                   as GENDER,
    "SPECIALITY"                 as SPECIALITY,
    "ADDRESS"                      as ADDRESS,
    "CITY"                           as CITY,
    "STATE"                            as STATE,
    "ZIP"                                as ZIP,
    "LAT"::double                          as LATITUDE,
    "LON"::double                            as LONGITUDE,
    "UTILIZATION"::integer                     as UTILIZATION
from {{ source('source', 'providers') }}