from google.cloud import bigquery
from dotenv import load_dotenv
import os

load_dotenv()

os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "./gcp.secrets.json"

def create_database(project_id, dataset_id):
    client = bigquery.Client()
    dataset_ref= bigquery.DatasetReference(project_id, dataset_id)
    dataset = bigquery.Dataset(dataset_ref)
    dataset.location = "US"

    # Cria o dataset
    dataset = client.create_dataset(dataset, exists_ok=True)
    return dataset_id

def create_table(project_id, dataset_id, table_id, schema):
    try:
        client = bigquery.Client()
        dataset_ref = bigquery.DatasetReference(project_id, dataset_id)
        table_ref = dataset_ref.table(table_id)
        table = bigquery.Table(table_ref, schema=schema)
        table.partitioning_type = "MONTH"
        table = client.create_table(table, exists_ok=True)
        return True
    except Exception:
        return False

def insert_data_from_parquet(project_id, dataset_id, table_id, parquet_file_path):
    client = bigquery.Client()
    table_ref = bigquery.DatasetReference(project_id, dataset_id).table(table_id)

    # Abre o arquivo Parquet e faz o upload
    with open(parquet_file_path, "rb") as file:
        job = client.load_table_from_file(
            file,
            table_ref,
            job_config=bigquery.LoadJobConfig(
                source_format=bigquery.SourceFormat.PARQUET,
                write_disposition=bigquery.WriteDisposition.WRITE_APPEND  # ou WRITE_TRUNCATE para sobrescrever
            )
        )

    job.result()
    print(f"Dados inseridos com sucesso na tabela {table_id} a partir do arquivo {parquet_file_path}.")



