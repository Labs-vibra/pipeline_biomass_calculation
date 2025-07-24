from airflow import DAG
from airflow.utils.dates import days_ago
from airflow.utils.task_group import TaskGroup
from airflow.providers.google.cloud.operators.bigquery import BigQueryInsertJobOperator
from airflow.providers.google.cloud.operators.cloud_run import CloudRunExecuteJobOperator
from airflow.providers.google.cloud.hooks.gcs import GCSHook
import os
import datetime as dt

default_args = {
    'owner': 'airflow',
    'start_date': days_ago(1),
    'retries': 1,
}

bucket = os.getenv("BUCKET_NAME", "vibra-dtan-juridico-anp-input")
project_id = os.getenv("GOOGLE_CLOUD_PROJECT", "labs-vibra-final")

params_dag = {
    'start_date': '2024-01-01',
    'end_date': '2024-12-31',
}

def get_sql_content(sql_path):
    gcs_hook = GCSHook()
    bucket_name, object_name = sql_path.replace('gs://', '').split('/', 1)
    return gcs_hook.download(bucket_name=bucket_name, object_name=object_name).decode('utf-8')

def populate_table(table, sql_name):
    return BigQueryInsertJobOperator(
        task_id=f"populate_query_{table}_job",
        configuration={
            "query": {
                "query": get_sql_content(sql_name),
                "useLegacySql": False
            }
        },
        params=params_dag,
        location="US"
    )

def exec_cloud_run_job(task_id, job_name):
    return CloudRunExecuteJobOperator(
        task_id=f"rw_extract_{task_id}_job",
        job_name=f"cr-juridico-{job_name}-dev",
        region='us-central1',
        project_id=project_id,
        deferrable=True,
        pool="cloud_run_pool",
        overrides={
            "container_overrides": [
                {
                    "env": [
                        {"name": "START_DATE", "value": params_dag['start_date']},
                        {"name": "END_DATE", "value": params_dag['end_date']}
                    ]
                }
            ],
        }
    )

with DAG(
    dag_id='biomass_calculation_dag_2024',
    default_args=default_args,
    description='Biomass Calculation DAG',
    schedule_interval='@monthly',
    catchup=False,
    max_active_tasks=2,
) as dag:

    # TaskGroup for ETL: Total Sales
    with TaskGroup("etl_total_sales", tooltip="ETL Total Sales") as etl_total_sales:
        run_total = exec_cloud_run_job(
            task_id="total_sales",
            job_name="etl-venda-total"
        )
        pop_total = populate_table(
            table="td_total_sales",
            sql_name=f"gs://{bucket}/sql/trusted/dml_total_sales.sql"
        )
        run_total >> pop_total

    # TaskGroup for ETL: B100 Sales
    with TaskGroup("etl_b100_sales", tooltip="ETL B100 Sales") as etl_b100_sales:
        run_b100 = exec_cloud_run_job(
            task_id="b100_sales",
            job_name="etl-venda-b100"
        )
        pop_b100 = populate_table(
            table="td_b100_sales",
            sql_name=f"gs://{bucket}/sql/trusted/dml_b100_sales.sql"
        )
        run_b100 >> pop_b100

    # TaskGroup for ETL: Congeneres Sales
    with TaskGroup("etl_congeneres_sales", tooltip="ETL Congeneres Sales") as etl_congeneres_sales:
        run_congeneres = exec_cloud_run_job(
            task_id="congeneres_sales",
            job_name="etl-venda-congeneres"
        )
        pop_congeneres = populate_table(
            table="td_congeneres_sales",
            sql_name=f"gs://{bucket}/sql/trusted/dml_congeneres_sales.sql"
        )
        run_congeneres >> pop_congeneres

    # TaskGroup for ETL: Dados Agentes
    with TaskGroup("etl_dados_agentes", tooltip="ETL Dados Agentes") as etl_dados_agentes:
        run_dados = exec_cloud_run_job(
            task_id="dados_agentes",
            job_name="etl-agentes-regulados-simp"
        )
        pop_dados = populate_table(
            table="td_dados_agentes",
            sql_name=f"gs://{bucket}/sql/trusted/dml_dados_agentes.sql"
        )
        run_dados >> pop_dados

    # Refined layer: Execute after all raw ETLs are complete
    refined_biomass = populate_table(
        table="rf_biomass_calculation",
        sql_name=f"gs://{bucket}/sql/refined/dml_biomass_calculation.sql"
    )

    # Establish overall dependency: run ETL taskgroups sequentially
    [etl_total_sales, etl_b100_sales, etl_congeneres_sales, etl_dados_agentes] >> refined_biomass