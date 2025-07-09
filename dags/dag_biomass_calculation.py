from airflow import DAG
from airflow.utils.dates import days_ago
from airflow.providers.google.cloud.operators.bigquery import BigQueryInsertJobOperator
from airflow.providers.google.cloud.operators.cloud_run import CloudRunJobRunOperator

# Define default arguments for the DAG
default_args = {
    'owner': 'airflow',
    'start_date': days_ago(1),
    'retries': 1,
}

# Run SQL using BQ
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

def run_cloud_run_job(task_id, job_name, region, project_id):
    return CloudRunJobRunOperator(
        task_id=task_id,
        job_name=job_name,
        region=region,
        project_id=project_id,
        wait_until_complete=True,
        poll_interval=10 #ver o intervalo necessário
    )

# principal DAG
with DAG(
    dag_id='biomass_calculation_dag',
    default_args=default_args,
    description='Biomass Calculation DAG',
    schedule_interval='@monthly',
    catchup=False,
) as dag:

    # Cloud Run Extractions
    extract_total_sales = run_cloud_run_job(
        task_id="000_extract_total_sales", #000 porque é extração
        job_name="ext-total-sales-job",
        region="us-central1",
    )

    extract_b100_sales = run_cloud_run_job(
        task_id="000_extract_b100_sales",
        job_name="ext-b100-sales-job",
        region="us-central1",
    )

    # Trusted Transformations
    rw_to_td_total_sales = execute_query_from_gcs(
        task_id='001_total_sales_execute_query', #001 porque é a trusted, 002 será o cálculo
        #query_gcs_path='gs://your-gcs-bucket/sql/trusted/td_ext_anp_total_sales.sql'
        # Não temos bucket ainda. Descomentar e incluir o bucket quando tivermos
    )

    rw_to_td_b100_sales = execute_query_from_gcs(
        task_id='001_b100_sales_execute_query',
        #query_gcs_path='gs://your-gcs-bucket/sql/trusted/td_ext_anp_venda_b100.sql'
        # Não temos bucket ainda. Descomentar e incluir o bucket quando tivermos
    )

    # Dependencies
    extract_total_sales >> rw_to_td_total_sales
    extract_b100_sales >> rw_to_td_b100_sales

    # forma como vai ficar no final: [rw_to_td_b100_sales, rw_to_td_total_sales] >> calculo
