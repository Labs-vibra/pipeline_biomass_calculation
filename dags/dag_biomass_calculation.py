from airflow import DAG
from airflow.utils.dates import days_ago
from airflow.providers.google.cloud.operators.bigquery import BigQueryInsertJobOperator
from airflow.providers.google.cloud.operators.cloud_run import CloudRunExecuteJobOperator
import os

default_args = {
    'owner': 'airflow',
    'start_date': days_ago(1),
    'retries': 1,
}

bucket = os.getenv("BUCKET_NAME", "anp-ext-bucket-etl")

params_dag = {
    'start_date': """
        {% set start = macros.ds_add(ds, -90) %}
        {% if start[:4] != ds[:4] %}
            {{ ds[:4] }}-01-01
        {% else %}
            {{ macros.ds_format(start, '%Y-%m-%d', '%Y-%m-01') }}
        {% endif %}
    """,
    'end_date': "{{ ds }}"
}

def execute_query_from_gcs(task_id, query_gcs_path):
    return BigQueryInsertJobOperator(
        task_id=task_id,
        configuration={
            "query": {
                "query": query_gcs_path,
                "useLegacySql": False
            }
        },
        params=params_dag,
        location="us-central1"
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