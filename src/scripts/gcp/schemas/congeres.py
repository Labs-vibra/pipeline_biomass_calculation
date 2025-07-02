from scripts.gcp.bq import create_database, create_table
from google.cloud import bigquery
from dotenv import load_dotenv
import os

load_dotenv()

rw_ext_anp_congeneres_sales_schema = [
    bigquery.SchemaField("date", "DATE"),
    bigquery.SchemaField("product", "STRING"),
    bigquery.SchemaField("from", "STRING"),
    bigquery.SchemaField("destination", "STRING"),
    bigquery.SchemaField("seller", "STRING"),
    bigquery.SchemaField("buyer", "STRING"),
    bigquery.SchemaField("volume_m3", "FLOAT"),
]


td_ext_anp_congeneres_sales_schema = [
    bigquery.SchemaField("date", "DATE"),
    bigquery.SchemaField("product", "STRING"),
    bigquery.SchemaField("from", "STRING"),
    bigquery.SchemaField("destination", "STRING"),
    bigquery.SchemaField("seller", "STRING"),
    bigquery.SchemaField("buyer", "STRING"),
    bigquery.SchemaField("volume_1000m3", "FLOAT"),
]

rw_dataset = "rw_ext_biomass_calculation"
td_dataset = "td_ext_biomass_calculation"


create_database(os.getenv("GOOGLE_PROJECT_ID"), rw_dataset)
create_database(os.getenv("GOOGLE_PROJECT_ID"), td_dataset)
create_table(os.getenv("GOOGLE_PROJECT_ID"), rw_dataset, "rw_ext_anp_congeneres_sales", rw_ext_anp_congeneres_sales_schema)
create_table(os.getenv("GOOGLE_PROJECT_ID"), td_dataset, "td_ext_anp_congeneres_sales", td_ext_anp_congeneres_sales_schema)