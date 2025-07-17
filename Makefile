PROJECT_ID ?= labs-vibra-final
ARTIFACT_REPO ?= ar-juridico-process-notebooks
BUCKET_NAME ?= vibra-dtan-juridico-anp-input
COMPOSE_BUCKET_NAME ?= $(BUCKET_NAME)

build-docker:
	docker build -t run-notebook-api .

build-docker-dev:
	docker build -f Dockerfile.dev -t run-notebook-api-dev .

run-docker-dev:
	docker run \
	-e NOTEBOOK_TO_BE_EXECUTED="./notebooks/rw_ext_anp_total_sales.ipynb" \
	run-notebook-api-dev

gcp-login:
	gcloud auth application-default login

run-docker:
	docker run \
	-e NOTEBOOK_URI="./notebooks/rw_ext_anp_congeneres_sales.ipynb" \
	run-notebook-api

configure-docker-gcp:
	gcloud auth configure-docker us-central1-docker.pkg.dev
	gcloud config set project $(PROJECT_ID)

upload-docker:
	docker build -t us-central1-docker.pkg.dev/$(PROJECT_ID)/${ARTIFACT_REPO}/run-notebook-api:latest .
	docker push us-central1-docker.pkg.dev/$(PROJECT_ID)/${ARTIFACT_REPO}/run-notebook-api:latest

create-venv:
	python3 -m venv .venv

install-requirements:
	.venv/bin/pip install -r requirements.txt

up-artifact:
	cd terraform; \
	terraform apply -target=google_artifact_registry_repository.anp_repo_etl -auto-approve

upload-infra: configure-docker-gcp up-artifact upload-docker
	cd terraform; \
	terraform apply -auto-approve

upload-data-to-gcs:
	gsutil cp -r src/notebooks/*.ipynb gs://$(BUCKET_NAME)/notebooks/
	gsutil cp -r src/db/queries/* gs://$(BUCKET_NAME)/sql/
	gsutil cp -r src/db/schemas/* gs://$(BUCKET_NAME)/sql/schemas/

upload-dags:
	gsutil cp -r dags/* gs://$(COMPOSE_BUCKET_NAME)/dags/

upload-infra: configure-docker-gcp up-artifact upload-docker upload-data-to-gcs upload-dags
	cd terraform; \
	terraform apply -auto-approve


