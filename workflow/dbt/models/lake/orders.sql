{{ config(materialized='table') }}

SELECT
    CAST(id AS VARCHAR) AS id,
    CAST(user_id AS VARCHAR) AS user_id,
    CAST(order_date AS DATE) AS order_date,
    CAST(status AS VARCHAR) AS status,
    CAST(year AS VARCHAR) AS year,
    CAST(month AS VARCHAR) AS month
FROM
    {{ source('external_source', 'orders') }}
