{{ config(materialized='incremental', unique_key='customer_id') }}

WITH renamed AS (
    SELECT
        CAST(id AS VARCHAR) AS customer_id,
        CAST(first_name AS VARCHAR) AS first_name,
        CAST(last_name AS VARCHAR) AS last_name
    FROM
        {{ source('external_source', 'stg_customers') }}
)

SELECT * FROM renamed
