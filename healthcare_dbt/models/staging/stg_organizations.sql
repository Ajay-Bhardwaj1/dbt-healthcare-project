{{ config(materialized='table') }}
select
    "Id"              as ORGANIZATION_ID,
    "NAME"              as ORGANIZATION_NAME,
    "ADDRESS"             as ADDRESS,
    "CITY"                  as CITY,
    "STATE"                   as STATE,
    "ZIP"                       as ZIP,
    "LAT"::double                 as LATITUDE,
    "LON"::double                   as LONGITUDE,
    "PHONE"                           as PHONE,
    "REVENUE"::double                   as REVENUE,
    "UTILIZATION"::integer                as UTILIZATION
from {{ source('source', 'organizations') }}