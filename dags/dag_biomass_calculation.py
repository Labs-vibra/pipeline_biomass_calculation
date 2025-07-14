from airflow import DAG
from airflow.utils.dates import days_ago
from airflow.providers.google.cloud.operators.bigquery import BigQueryInsertJobOperator
from airflow.providers.google.cloud.operators.cloud_run import CloudRunJobRunOperator
import os

default_args = {
    'owner': 'airflow',
    'start_date': days_ago(1),
    'retries': 1,
}

bucket = os.getenv("BUCKET_NAME", "anp-ext-bucket-etl")

def execute_query_from_gcs(task_id, query_gcs_path):
    return BigQueryInsertJobOperator(
        task_id=task_id,
        configuration={
            "query": {
                "query": query_gcs_path,
                "useLegacySql": False
            }
        },
        params={
            "start_date": "{{ macros.ds_format(ds, '%Y-%m-%d', '%Y-%m-01') }}",
            "end_date": "{{ ds }}"
        },
        location="us"
    )

def run_cloud_run_job(task_id, job_name):
    return CloudRunJobRunOperator(
        task_id=task_id,
        job_name=job_name,
        region='us-central1',
        project_id=os.getenv("GOOGLE_CLOUD_PROJECT"),
        wait_until_complete=True,
    )

with DAG(
    dag_id='biomass_calculation_dag',
    default_args=default_args,
    description='Biomass Calculation DAG',
    schedule_interval='@monthly',
    catchup=False,
) as dag:

    extract_total_sales = run_cloud_run_job(
        task_id="000_extract_total_sales",
        job_name="ext-total-sales",
    )

    extract_b100_sales = run_cloud_run_job(
        task_id="000_extract_b100_sales",
        job_name="ext-b100-sales",
    )

    extract_congeneres_sales = run_cloud_run_job(
        task_id="000_extract_congeneres_sales",
        job_name="ext-congeneres-sales",
    )

    rw_total_sales = execute_query_from_gcs(
        task_id='001_total_sales_execute_query',
        query_gcs_path=f'gs://{bucket}/sql/raw/ddl_total_sales.sql'
    )

    rw_b100_sales = execute_query_from_gcs(
        task_id='001_b100_sales_execute_query',
        query_gcs_path=f'gs://{bucket}/sql/raw/ddl_b100.sql'
    )

    rw_congeneres_sales = execute_query_from_gcs(
        task_id='001_congeneres_sales_execute_query',
        query_gcs_path=f'gs://{bucket}/sql/raw/ddl_congeneres.sql'
    )

    td_total_sales = execute_query_from_gcs(
        task_id='002_total_sales_execute_query',
        query_gcs_path=f'gs://{bucket}/sql/trusted/ddl_total_sales.sql'
    )

    td_b100_sales = execute_query_from_gcs(
        task_id='002_b100_sales_execute_query',
        query_gcs_path=f'gs://{bucket}/sql/trusted/ddl_b100.sql'
    )

    td_congeneres_sales = execute_query_from_gcs(
        task_id='002_congeneres_sales_execute_query',
        query_gcs_path=f'gs://{bucket}/sql/trusted/ddl_congeneres.sql'
    )

    rf_biomass_calculation = execute_query_from_gcs(
        task_id='002_biomass_calculation_execute_query',
        query_gcs_path=f'gs://{bucket}/sql/refined/ddl_biomass_calculation.sql'
    )

    extract_b100_sales >> rw_b100_sales >> td_b100_sales
    extract_total_sales >> rw_total_sales >> td_total_sales
    extract_congeneres_sales >> rw_congeneres_sales >> td_congeneres_sales

    [td_b100_sales, td_total_sales, td_congeneres_sales] >> rf_biomass_calculation