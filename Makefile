build-docker:
	docker build -t run-notebook-api ./api

run-docker-local:
	docker run -p 8000:8000 -e NOTEBOOK_GCS_URI="gs://anp-tests-biomass-calc/teste.ipynb" run-notebook-api

configure-docker-gcp:
	gcloud auth configure-docker
	gcloud config set project labs-vibra

upload-docker:
	docker build -t gcr.io/labs-vibra/run-notebook-api .
	docker push gcr.io/labs-vibra/run-notebook-api