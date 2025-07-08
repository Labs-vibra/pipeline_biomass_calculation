build-docker:
	docker build -t run-notebook-api .

build-docker-dev:
	docker build -f Dockerfile.dev -t run-notebook-api-dev .

run-docker-dev:
	docker run \
	-e NOTEBOOK_URI="./notebooks/rw_ext_anp_total_sales.ipynb" \
	run-notebook-api-dev

run-docker:
	docker run \
	-e NOTEBOOK_URI="./notebooks/rw_ext_anp_total_sales.ipynb" \
	run-notebook-api

configure-docker-gcp:
	gcloud auth configure-docker
	gcloud config set project labs-vibra

upload-docker:
	docker build -t us-central1-docker.pkg.dev/labs-vibra/anp-repo-etl/run-notebook-api:latest .
	docker push us-central1-docker.pkg.dev/labs-vibra/anp-repo-etl/run-notebook-api:latest