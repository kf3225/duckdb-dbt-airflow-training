{{ config(materialized='incremental', unique_key='payment_id') }}

WITH renamed AS (
    SELECT
        CAST(id AS VARCHAR) AS payment_id,
        CAST(order_id AS VARCHAR) AS order_id,
        CAST(payment_method AS VARCHAR) AS payment_method,
        CAST(amount AS INTEGER) AS amount,
        CAST(year AS VARCHAR) AS payment_year,
        CAST(month AS VARCHAR) AS payment_month
    FROM
        {{ source('external_source', 'stg_payments') }}
    {% if var('target_year', '') != '' and var('target_month', '') != '' %}
        WHERE
            year = '{{ var('target_year') }}'
            AND month = '{{ var('target_month') }}'
    {% endif %}
)

SELECT * FROM renamed
