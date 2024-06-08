FROM apache/airflow:2.9.1

COPY ./workflow/requirements.lock /opt/airflow
COPY ./workflow/pyproject.toml /opt/airflow
COPY ./workflow/README.md /opt/airflow

WORKDIR /opt/airflow

RUN python -m pip install -r requirements.lock
