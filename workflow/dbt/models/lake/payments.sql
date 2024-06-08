{{ config(materialized='table') }}

SELECT
    CAST(id AS VARCHAR) AS id,
    CAST(order_id AS VARCHAR) AS order_id,
    CAST(payment_method AS VARCHAR) AS payment_method,
    CAST(amount AS INTEGER) AS amount,
    CAST(year AS VARCHAR) AS year,
    CAST(month AS VARCHAR) AS month
FROM
    {{ source('external_source', 'payments') }}
