from airflow import DAG
from airflow.utils.dates import days_ago
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

params_dag = {
    'start_date': (dt.datetime.now() - dt.timedelta(days=90)).strftime('%Y-%m-%d'),
    'end_date': dt.datetime.now().strftime('%Y-%m-%d'),
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
        location="us-central1"
    )

def exec_cloud_run_job(task_id, job_name):
    return CloudRunExecuteJobOperator(
        task_id=f"rw_extract_{task_id}_job",
        job_name=f"cr-juridico-{job_name}-dev",
        region='us-central1',
        project_id=os.getenv("GOOGLE_CLOUD_PROJECT"),
        deferrable=True
    )

with DAG(
    dag_id='biomass_calculation_dag',
    default_args=default_args,
    description='Biomass Calculation DAG',
    schedule_interval='@monthly',
    catchup=False,
) as dag:

    rw_total_sales = exec_cloud_run_job(
        task_id="total_sales",
        job_name="etl-venda-total",
    )

    rw_b100_sales = exec_cloud_run_job(
        task_id="b100_sales",
        job_name="etl-venda-b100",
    )

    rw_congeneres_sales = exec_cloud_run_job(
        task_id="congeneres_sales",
        job_name="etl-venda-congeneres",
    )

    rw_dados_agentes = exec_cloud_run_job(
        task_id="dados_agentes",
        job_name="etl-agentes-regulados-simp",
    )

    td_dados_agentes = populate_table(
        table="td_dados_agentes",
        sql_name=f'gs://{bucket}/sql/trusted/dml_dados_agentes.sql'
    )

    td_total_sales = populate_table(
        table="td_total_sales",
        sql_name=f'gs://{bucket}/sql/trusted/dml_total_sales.sql'
    )

    td_b100_sales = populate_table(
        table="td_b100_sales",
        sql_name=f'gs://{bucket}/sql/trusted/dml_b100_sales.sql'
    )

    td_congeneres_sales = populate_table(
        table="td_congeneres_sales",
        sql_name=f'gs://{bucket}/sql/trusted/dml_congeneres_sales.sql'
    )

    rf_biomass_calculation = populate_table(
        table="rf_biomass_calculation",
        sql_name=f'gs://{bucket}/sql/refined/dml_biomass_calculation.sql'
    )

    rw_total_sales >> td_total_sales
    rw_b100_sales >> td_b100_sales
    rw_congeneres_sales >> td_congeneres_sales
    rw_dados_agentes >> td_dados_agentes
    [td_total_sales, td_b100_sales, td_congeneres_sales] >> td_dados_agentes >> rf_biomass_calculation
