import subprocess
from google.cloud import storage

try:
    BUCKET_NAME = "your-bucket-name"  # Replace with your VIBRA BUCKET_NAME
    BUCKET_FILE_PATH = "data/notebooks/"

    COMMAND_GET_ALL_DAGS = "find dags -name '*.py'"
    COMMAND_VERIFY_DEST_DIR = "rm -rf ./dist/ && mkdir -p ./dist/"
    result = subprocess.run(COMMAND_GET_ALL_DAGS, capture_output=True, text=True, shell=True, check=True)
    system_abs_path = subprocess.run("pwd", capture_output=True, text=True, shell=True, check=True).stdout.strip()
    file_paths = result.stdout.strip().split('\n')
    file_abs_paths = [f"{system_abs_path}/{path}" for path in file_paths if path]
    subprocess.run(COMMAND_VERIFY_DEST_DIR, shell=True, check=True)

    for file_path in file_abs_paths:
        client = storage.Client()
        bucket = client.bucket(BUCKET_NAME)
        blob = bucket.blob(BUCKET_FILE_PATH + file_path.split('/')[-1])
        blob.upload_from_filename(file_path)

    print("Upload completed.")
except:
    print("Error: BUCKET_NAME is not set. Please set it to your VIBRA BUCKET_NAME.")
    exit(1)