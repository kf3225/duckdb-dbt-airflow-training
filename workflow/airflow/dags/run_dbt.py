import pendulum
from airflow.decorators import dag, task
from airflow_dbt.operators.dbt_operator import DbtRunOperator
from duckdb import DuckDBPyConnection
from duckdb import connect as duckdb_connect


def get_connection() -> DuckDBPyConnection:
    conn = duckdb_connect("/tmp/store_data.db")
    return conn


@task
def select_tables():
    t1, t2, t3 = "customers", "payments", "orders"
    conn = get_connection()
    res = conn.sql(f"select * from {t1}")
    print(res)
    res = conn.sql(f"select * from {t2}")
    print(res)
    res = conn.sql(f"select * from {t3}")
    print(res)


@dag(
    schedule=None, start_date=pendulum.datetime(2024, 1, 1), catchup=False, tags=["dbt"]
)
def run_dbt_workflow():
    DbtRunOperator(task_id="dbt-run", dir="/opt/dbt") >> select_tables()


dag = run_dbt_workflow()
