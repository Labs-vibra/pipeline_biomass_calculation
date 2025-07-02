import subprocess
from sys import argv
from google.cloud import storage

try:
    BUCKET_NAME = "your-bucket-name"  # Replace with your VIBRA BUCKET_NAME
    BUCKET_FILE_PATH = f"data/notebooks/"
    DEST_DIR = "./dist/"

    COMMAND_GET_ALL_NOTEBOOKS = "find notebooks -name '*.ipynb'"
    COMMAND_VERIFY_DEST_DIR = f"rm -rf {DEST_DIR} && mkdir -p {DEST_DIR}"

    result = subprocess.run(COMMAND_GET_ALL_NOTEBOOKS, capture_output=True, text=True, shell=True, check=True)
    system_abs_path = subprocess.run("pwd", capture_output=True, text=True, shell=True, check=True).stdout.strip()
    file_paths = result.stdout.strip().split('\n')
    file_abs_paths = [f"{system_abs_path}/{path}" for path in file_paths if path]

    subprocess.run(COMMAND_VERIFY_DEST_DIR, shell=True, check=True)

    if len(argv) == 2 and argv[1] == "--upload":
        for file_path in file_abs_paths:
            client = storage.Client()
            bucket = client.bucket(BUCKET_NAME)
            blob = bucket.blob(BUCKET_FILE_PATH + file_path.split('/')[-1])
            blob.upload_from_filename(file_path)
        print("Upload completed.")
    else:
        for file_path in file_abs_paths:
            subprocess.run(f"cp {file_path} {DEST_DIR}", shell=True, check=True)
    print("Deployment script executed successfully.")
except subprocess.CalledProcessError as e:
    print(f"An error occurred while executing the deployment script: {e}")
except Exception as e:
    print(f"An unexpected error occurred: {e}")