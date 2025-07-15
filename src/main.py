import os
import papermill as pm
import datetime

notebook_params = {
    'start_date': (datetime.datetime.now() - datetime.timedelta(days=120)).strftime('%Y-%m-%d'),
    'end_date': datetime.datetime.now().strftime('%Y-%m-%d'),
}
if notebook_params['start_date'][:4] != notebook_params['end_date'][:4]:
    notebook_params['start_date'] = f"{notebook_params['end_date'][:4]}-01-01"
    notebook_params['end_date'] = f"{notebook_params['end_date'][:4]}-{notebook_params['end_date'][5:7]}-{notebook_params['end_date'][8:10]}"

notebook_gcs_uri = os.getenv("NOTEBOOK_TO_BE_EXECUTED")
notebook_name = notebook_gcs_uri.split("/")[-1] if notebook_gcs_uri else os.getenv("NOTEBOOK_OUTPUT_GCS_URL")
if not notebook_gcs_uri:
    raise ValueError("NOTEBOOK_TO_BE_EXECUTED environment variable is not set")
output_formatted_name = notebook_name.replace(".ipynb", "_output.ipynb")
notebook_output_path = notebook_gcs_uri.replace(notebook_name, f"output/{output_formatted_name}")
pm.execute_notebook(notebook_gcs_uri, notebook_output_path, parameters=notebook_params)

print(f"Notebook executed successfully. Output saved to: {notebook_output_path}")