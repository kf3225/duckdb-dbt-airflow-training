{{ config(materialized='table') }}

SELECT
    CAST(id AS VARCHAR) AS id,
    CAST(first_name AS VARCHAR) AS first_name,
    CAST(last_name AS VARCHAR) AS last_name
FROM
    {{ source('external_source', 'customers') }}
