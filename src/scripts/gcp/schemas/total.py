from google.cloud import bigquery
from dotenv import load_dotenv
import os

from scripts.gcp.bq import create_database, create_table

load_dotenv()

rw_ext_anp_total_sales_schema = [
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

td_ext_anp_total_sales_schema = [
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

rw_dataset = "rw_ext_biomass_calculation"
td_dataset = "td_ext_biomass_calculation"

create_database(os.getenv("GOOGLE_PROJECT_ID"), rw_dataset)
create_database(os.getenv("GOOGLE_PROJECT_ID"), td_dataset)
create_table(os.getenv("GOOGLE_PROJECT_ID"), rw_dataset, "rw_ext_anp_total_sales", rw_ext_anp_total_sales_schema)
create_table(os.getenv("GOOGLE_PROJECT_ID"), td_dataset, "td_ext_anp_total_sales", td_ext_anp_total_sales_schema)