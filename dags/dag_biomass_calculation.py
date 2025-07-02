from airflow import DAG
from airflow.providers.http.operators.http import SimpleHttpOperator
from airflow.utils.dates import days_ago
from airflow.providers.google.cloud.operators.bigquery import BigQueryOperator

# Define default arguments for the DAG
default_args = {
    'owner': 'airflow',
    'start_date': days_ago(1), # This DAG will start from yesterday
    'retries': 1,
}

def execute_querty_from_gcs(query_gcs_path):
    return BigQueryOperator(
        task_id='execute_bigquery_query_from_gcs',
        sql=query_gcs_path,
        gcp_conn_id='google_cloud_default',
        write_disposition='WRITE_TRUNCATE'
    )

with DAG(
    dag_id='biomass_calculation_dag',
    default_args=default_args,
    description='Biomass Calculation DAG',
    schedule_interval='@monthly',
    catchup=False,
) as dag:

    extract_total_sales = SimpleHttpOperator(
        task_id='000_extract_total_sales',
        http_conn_id='total_sales_api',
        endpoint='/',
        method='GET',
        response_check=lambda response: response.status_code == 200,
        log_response=True,
    )

    rw_to_td_execute_query = execute_querty_from_gcs(
        query_gcs_path="gs://your-gcs-bucket/path/to/your_query.sql"
    )

    extract_total_sales >> rw_to_td_execute_query
