from google.cloud import bigquery
from dotenv import load_dotenv
import os

from scripts.gcp.bq import create_database, create_table

load_dotenv()


rw_ext_anp_market_sales_schema =[
    bigquery.SchemaField("date", "DATE"),
    bigquery.SchemaField("destination", "STRING"),
    bigquery.SchemaField("product", "STRING"),
    bigquery.SchemaField("seller", "STRING"),
    bigquery.SchemaField("volume", "FLOAT"),
]

td_ext_anp_market_sales_schema =[
    bigquery.SchemaField("date", "DATE"),
    bigquery.SchemaField("destination", "STRING"),
    bigquery.SchemaField("product", "STRING"),
    bigquery.SchemaField("company_name", "STRING"),
    bigquery.SchemaField("volume_1000m3", "FLOAT"),
]

rw_dataset = "rw_ext_biomass_calculation"
td_dataset = "td_ext_biomass_calculation"

create_database(os.getenv("GOOGLE_PROJECT_ID"), rw_dataset)
create_database(os.getenv("GOOGLE_PROJECT_ID"), td_dataset)

create_table(os.getenv("GOOGLE_PROJECT_ID"), rw_dataset, "rw_ext_anp_market_sales", rw_ext_anp_market_sales_schema)