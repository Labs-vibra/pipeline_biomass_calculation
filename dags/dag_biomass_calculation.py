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

bucket = os.getenv("BUCKET_NAME", "anp-ext-bucket-etl")

#start date last 3 months
params_dag = {
    'start_date': (dt.datetime.now() - dt.timedelta(days=90)).strftime('%Y-%m-%d'),
    'end_date': dt.datetime.now().strftime('%Y-%m-%d'),
}

def getSqlContentFromGCS(query_gcs_path):
    gcs_hook = GCSHook()
    bucket_name, object_name = query_gcs_path.replace('gs://', '').split('/', 1)
    return gcs_hook.download(bucket_name=bucket_name, object_name=object_name).decode('utf-8')

def execute_query_from_gcs(task_id, query_gcs_path):
    get_sql_from_gcs = getSqlContentFromGCS(query_gcs_path)
    return BigQueryInsertJobOperator(
        task_id=task_id,
        configuration={
            "query": {
                "query": get_sql_from_gcs,
                "useLegacySql": False
            }
        },
        params=params_dag,
        location="US"
    )

def exec_cloud_run_job(task_id, job_name):
    return CloudRunExecuteJobOperator(
        task_id=task_id,
        job_name=job_name,
        region='europe-west1',
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
        task_id="000_extract_total_sales",
        job_name="ext-total-sales",
    )

    rw_b100_sales = exec_cloud_run_job(
        task_id="000_extract_b100_sales",
        job_name="ext-b100-sales",
    )

    rw_congeneres_sales = exec_cloud_run_job(
        task_id="000_extract_congeneres_sales",
        job_name="ext-congeneres-sales",
    )

    td_total_sales = execute_query_from_gcs(
        task_id='001_total_sales_execute_query',
        query_gcs_path=f'gs://{bucket}/sql/trusted/dml_total_sales.sql'
    )

    td_b100_sales = execute_query_from_gcs(
        task_id='001_b100_sales_execute_query',
        query_gcs_path=f'gs://{bucket}/sql/trusted/dml_b100_sales.sql'
    )

    td_congeneres_sales = execute_query_from_gcs(
        task_id='001_congeneres_sales_execute_query',
        query_gcs_path=f'gs://{bucket}/sql/trusted/dml_congeneres_sales.sql'
    )

    rf_biomass_calculation = execute_query_from_gcs(
        task_id='002_biomass_calculation_execute_query',
        query_gcs_path=f'gs://{bucket}/sql/refined/dml_biomass_calculation.sql'
    )

    rw_b100_sales >> td_b100_sales
    rw_total_sales >> td_total_sales
    rw_congeneres_sales >> td_congeneres_sales

    [td_b100_sales, td_total_sales, td_congeneres_sales] >> rf_biomass_calculation