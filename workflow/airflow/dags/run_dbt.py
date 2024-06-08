from typing import Literal

import pendulum
from airflow.decorators import dag, task
from airflow.models.param import Param
from airflow.operators.python import get_current_context
from airflow_dbt.operators.dbt_operator import DbtRunOperator
from duckdb import DuckDBPyConnection
from duckdb import connect as duckdb_connect


def get_connection() -> DuckDBPyConnection:
    conn = duckdb_connect("/tmp/store_data.db")
    return conn


@dag(
    schedule=None,
    start_date=pendulum.datetime(2018, 1, 1),
    catchup=False,
    tags=["dbt"],
    params={
        "target_date": Param(
            default=pendulum.date(2018, 1, 1).strftime("%Y-%m-%d"),
            type="string",
            format="date",
        )
    },
)
def run_dbt_workflow():
    @task
    def generate_target_date() -> dict[Literal["target_year", "target_month"], str]:
        context = get_current_context()
        target_date = context.get("params", {}).get("target_date", "")
        target_date = pendulum.from_format(target_date, "YYYY-MM-DD")
        return {
            "target_year": f"{target_date.year:04d}",
            "target_month": f"{target_date.month:02d}",
        }

    def run_dbt(target_date: dict[str, str]) -> DbtRunOperator:
        return DbtRunOperator(
            task_id="dbt_run",
            dir="/opt/dbt",
            vars={
                "target_year": target_date["target_year"],
                "target_month": target_date["target_month"],
            },
        )

    @task
    def select_tables():
        conn = get_connection()
        for table in ("mart_customers", "mart_orders"):
            res = conn.sql(f"select * from {table}")
            print(res)

    target_date = generate_target_date()
    dbt_run = run_dbt(target_date)
    dbt_run >> select_tables()


dag = run_dbt_workflow()
