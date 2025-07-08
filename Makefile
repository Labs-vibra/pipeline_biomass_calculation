build-docker:
	docker build -t run-notebook-api ./api

build-docker-local:
	docker build -t run-notebook-api .

run-docker-local: build-docker-local
	docker run -e NOTEBOOK_GCS_URI="./notebooks/rw_ext_anp_total_sales.ipynb" run-notebook-api

configure-docker-gcp:
	gcloud auth configure-docker
	gcloud config set project labs-vibra

upload-docker:
	docker build -t us-central1-docker.pkg.dev/labs-vibra/anp-repo-etl/run-notebook-api:latest ./api
	docker push us-central1-docker.pkg.dev/labs-vibra/anp-repo-etl/run-notebook-api:latest