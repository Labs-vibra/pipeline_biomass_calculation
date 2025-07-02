def get_pipeline_notebook_path(pipeline_name, layer, pipeline_folder=None):
    base_path = f"notebooks/{pipeline_name if pipeline_folder is None else pipeline_folder}_sales_pipeline/{layer}_{pipeline_name}_sales.ipynb"
    print(f"Running notebook: {base_path}")
    return {
        "input": base_path,
        "output": "./output/" + base_path.split("/")[-1].replace(".ipynb", "_output.ipynb")
    }