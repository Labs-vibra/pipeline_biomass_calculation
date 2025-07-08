import os
import papermill as pm

def main():
    notebook_gcs_uri = os.getenv("NOTEBOOK_GCS_URI")
    notebook_name = notebook_gcs_uri.split("/")[-1] if notebook_gcs_uri else os.getenv("NOTEBOOK_OUTPUT_GCS_URL")
    if not notebook_gcs_uri:
        raise ValueError("NOTEBOOK_GCS_URI environment variable is not set")
    output_formatted_name = notebook_name.replace(".ipynb", "_output.ipynb")
    notebook_output_path = notebook_gcs_uri.replace(notebook_name, f"output/{output_formatted_name}")
    pm.execute_notebook(notebook_gcs_uri, notebook_output_path)
    return {
        "message": "notebook executed successfully",
        "input_notebook_uri": notebook_gcs_uri,
        "output_notebook_uri": notebook_output_path,
        "status": 200,
    }

main()