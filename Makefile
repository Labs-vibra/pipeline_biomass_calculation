PROJECT_ID ?= named-embassy-456813-f3

build-docker:
	docker build -t run-notebook-api .

build-docker-dev:
	docker build -f Dockerfile.dev -t run-notebook-api-dev .

run-docker-dev:
	docker run \
	-e NOTEBOOK_URI="./notebooks/rw_ext_anp_total_sales.ipynb" \
	run-notebook-api-dev

gcp-login:
	gcloud auth application-default login

run-docker:
	docker run \
	-e NOTEBOOK_URI="./notebooks/rw_ext_anp_congeneres_sales.ipynb" \
	run-notebook-api

configure-docker-gcp:
	gcloud auth configure-docker
	gcloud config set project $(PROJECT_ID)

upload-docker:
	docker build -t us-central1-docker.pkg.dev/$(PROJECT_ID)/anp-repo-etl/run-notebook-api:latest .
	docker push us-central1-docker.pkg.dev/$(PROJECT_ID)/anp-repo-etl/run-notebook-api:latest

create-venv:
	python3 -m venv .venv

install-requirements:
	.venv/bin/pip install -r requirements.txt
