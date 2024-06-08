{{ config(materialized='incremental', unique_key='order_id') }}

WITH renamed AS (
    SELECT
        CAST(id AS VARCHAR) AS order_id,
        CAST(user_id AS VARCHAR) AS customer_id,
        CAST(order_date AS DATE) AS order_date,
        CAST(status AS VARCHAR) AS status,
        CAST(year AS VARCHAR) AS order_year,
        CAST(month AS VARCHAR) AS order_month
    FROM
        {{ source('external_source', 'stg_orders') }}
    {% if var('target_year', '') != '' and var('target_month', '') != '' %}
        WHERE
            year = '{{ var('target_year') }}'
            AND month = '{{ var('target_month') }}'
    {% endif %}
)

SELECT * FROM renamed
