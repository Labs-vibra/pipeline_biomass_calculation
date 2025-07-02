from notebooks.scripts.gcp.bq import create_database, create_table
from google.cloud import bigquery
from dotenv import load_dotenv
import os

load_dotenv()

os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "./gcp.secrets.json"

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

rf_dataset = "rf_ext_biomass_calculation"

create_database(os.getenv("GOOGLE_PROJECT_ID"), rf_dataset)

create_table(os.getenv("GOOGLE_PROJECT_ID"), rf_dataset, "anp_biomass_calculation", biomass_calculation_schema)
