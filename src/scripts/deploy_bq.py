from google.cloud import bigquery
import os
from dotenv import load_dotenv

load_dotenv()

def create_dataset(project_id, dataset_id):
    client = bigquery.Client()
    dataset_ref= bigquery.DatasetReference(project_id, dataset_id)
    dataset = bigquery.Dataset(dataset_ref)
    dataset.location = "US"

    # Cria o dataset
    dataset = client.create_dataset(dataset, exists_ok=True)
    return dataset_id

def create_table(project_id, dataset_id, table_id, schema):
    try:
        print(f"Creating table {table_id} in dataset {dataset_id} of project {project_id}")
        client = bigquery.Client()
        dataset_ref = bigquery.DatasetReference(project_id, dataset_id)
        table_ref = dataset_ref.table(table_id)
        table = bigquery.Table(table_ref, schema=schema)
        table.partitioning_type = "MONTH"
        table = client.create_table(table, exists_ok=True)
        return True
    except Exception:
        return False

b100_sales_bronze_schema=[
    bigquery.SchemaField("date", "DATE"),
    bigquery.SchemaField("company_base_cnpj", "STRING"),
    bigquery.SchemaField("company_name", "STRING"),
    bigquery.SchemaField("volume_m3", "FLOAT"),
    bigquery.SchemaField("producer_name", "STRING"),
    bigquery.SchemaField("producer_cnpj", "STRING"),
]

b100_sales_silver_schema=[
    bigquery.SchemaField("date", "DATE"),
    bigquery.SchemaField("company_base_cnpj", "STRING"),
    bigquery.SchemaField("company_name", "STRING"),
    bigquery.SchemaField("volume_1000m3", "FLOAT"),
    bigquery.SchemaField("producer_name", "STRING"),
    bigquery.SchemaField("producer_cnpj", "STRING"),
]

congeneres_sales_bronze_schema = [
    bigquery.SchemaField("date", "DATE"),
    bigquery.SchemaField("product", "STRING"),
    bigquery.SchemaField("from", "STRING"),
    bigquery.SchemaField("destination", "STRING"),
    bigquery.SchemaField("seller", "STRING"),
    bigquery.SchemaField("buyer", "STRING"),
    bigquery.SchemaField("volume", "FLOAT"),
]


congeneres_sales_silver_schema = [
    bigquery.SchemaField("date", "DATE"),
    bigquery.SchemaField("product", "STRING"),
    bigquery.SchemaField("from", "STRING"),
    bigquery.SchemaField("destination", "STRING"),
    bigquery.SchemaField("seller", "STRING"),
    bigquery.SchemaField("buyer", "STRING"),
    bigquery.SchemaField("volume_1000m3", "FLOAT"),
]

market_sales_bronze_schema =[
    bigquery.SchemaField("date", "DATE"),
    bigquery.SchemaField("destination", "STRING"),
    bigquery.SchemaField("product", "STRING"),
    bigquery.SchemaField("seller", "STRING"),
    bigquery.SchemaField("volume", "FLOAT"),
]

market_sales_silver_schema =[
    bigquery.SchemaField("date", "DATE"),
    bigquery.SchemaField("destination", "STRING"),
    bigquery.SchemaField("product", "STRING"),
    bigquery.SchemaField("company_name", "STRING"),
    bigquery.SchemaField("volume_1000m3", "FLOAT"),
]

general_sales_bronze_schema = [
    bigquery.SchemaField("date", "DATE"),
    bigquery.SchemaField("month", "INTEGER"),
    bigquery.SchemaField("company_name", "STRING"),
    bigquery.SchemaField("company_base_cnpj", "STRING"),
    bigquery.SchemaField("producer_name", "STRING"),
    bigquery.SchemaField("volume_1000m3", "FLOAT"),
    bigquery.SchemaField("product", "STRING"),
    bigquery.SchemaField("origin_region", "STRING"),
    bigquery.SchemaField("origin_state", "STRING"),
    bigquery.SchemaField("destination_region", "STRING"),
    bigquery.SchemaField("destination_state", "STRING"),
]

general_sales_silver_schema = [
    bigquery.SchemaField("date", "DATE"),
    bigquery.SchemaField("company_name", "STRING"),
    bigquery.SchemaField("company_base_cnpj", "STRING"),
    bigquery.SchemaField("producer_name", "STRING"),
    bigquery.SchemaField("volume_1000m3", "FLOAT"),
    bigquery.SchemaField("product", "STRING"),
    bigquery.SchemaField("origin_region", "STRING"),
    bigquery.SchemaField("origin_state", "STRING"),
    bigquery.SchemaField("destination_region", "STRING"),
    bigquery.SchemaField("destination_state", "STRING"),
]

biomass_calculation_schema = [
    bigquery.SchemaField("id", "INTEGER"),
    bigquery.SchemaField("date", "DATE"),
    bigquery.SchemaField("cnpj", "STRING"),
    bigquery.SchemaField("company_name", "STRING"),
    bigquery.SchemaField("theoretical_b100_needs", "FLOAT"),
    bigquery.SchemaField("liquid_b100_purchases", "FLOAT"),
    bigquery.SchemaField("biodiesel_gap", "FLOAT"),
    bigquery.SchemaField("stock_variation", "INTEGER"),
    bigquery.SchemaField("liquid_b100_gap", "FLOAT"),
]

b100_dataset = "anp_b100_sales"
congeneres_dataset = "anp_congeneres_sales"
market_dataset = "anp_market_data"
total_dataset = "anp_total_sales"
anp_biomass_calculation_dataset = "anp_biomass_calculation"

project_id = os.getenv("GOOGLE_CLOUD_PROJECT")

create_dataset(project_id, b100_dataset)
create_table(project_id, b100_dataset, "b100_sales_bronze", b100_sales_bronze_schema)
create_table(project_id, b100_dataset, "b100_sales_silver", b100_sales_silver_schema)

create_dataset(project_id, congeneres_dataset)
create_table(project_id, congeneres_dataset, "congeneres_sales_bronze", congeneres_sales_bronze_schema)
create_table(project_id, congeneres_dataset, "congeneres_sales_silver", congeneres_sales_silver_schema)

create_dataset(project_id, market_dataset)
create_table(project_id, market_dataset, "market_sales_bronze", market_sales_bronze_schema)
create_table(project_id, market_dataset, "market_sales_silver", market_sales_silver_schema)

create_dataset(project_id, total_dataset)
create_table(project_id, total_dataset, "general_sales_bronze", general_sales_bronze_schema)
create_table(project_id, total_dataset, "general_sales_silver", general_sales_silver_schema)

create_dataset(project_id, anp_biomass_calculation_dataset)
create_table(project_id, anp_biomass_calculation_dataset, "anp_biomass_calculation", biomass_calculation_schema)
