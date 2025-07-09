resource "google_storage_bucket" "anp_bucket_etl" {
  name     = "anp-bucket-etl"
  location = var.region
  force_destroy = true
}

resource "google_artifact_registry_repository" "anp_repo_etl" {
    repository_id     = "anp-repo-etl"
    location = var.region
    format   = "DOCKER"

    description = "Repositório de artefatos para o projeto ANP"
    project  = var.project_id
}

resource "google_cloud_run_v2_job" "anp_vendas_b100_job" {
    name     = "anp-vendas-b100-job"
    location = var.region
    project  = var.project_id
    template {
        template {
            containers {
                image = "${var.region}-docker.pkg.dev/${var.project_id}/anp-repo-etl/run-notebook-api:latest"
                env {
                    name  = "NOTEBOOK_URI"
                    value = "gs://${google_storage_bucket.anp_bucket_etl.name}/notebooks/rw_ext_anp_b100_sales.ipynb"
                }
                resources {
                    limits = {
                        cpu    = "2"
                        memory = "1024Mi"
                    }
                }
            }
        }
    }
}

resource "google_cloud_run_v2_job" "anp_vendas_total_job" {
    name     = "anp-vendas-total-job"
    location = var.region
    project  = var.project_id
    template {
        template {
            containers {
                image = "${var.region}-docker.pkg.dev/${var.project_id}/anp-repo-etl/run-notebook-api:latest"
                env {
                    name  = "NOTEBOOK_URI"
                    value = "gs://${google_storage_bucket.anp_bucket_etl.name}/notebooks/rw_ext_anp_b100_sales.ipynb"
                }
                resources {
                    limits = {
                        cpu    = "2"
                        memory = "1024Mi"
                    }
                }
            }
        }
    }
}

resource "google_cloud_run_v2_job" "anp_vendas_congeneres" {
    name     = "anp-vendas-congeneres-job"
    location = var.region
    project  = var.project_id
    template {
        template {
            containers {
                image = "${var.region}-docker.pkg.dev/${var.project_id}/anp-repo-etl/run-notebook-api:latest"
                env {
                    name  = "NOTEBOOK_URI"
                    value = "gs://${google_storage_bucket.anp_bucket_etl.name}/notebooks/rw_ext_anp_congeneres_sales.ipynb"
                }
                resources {
                    limits = {
                        cpu    = "2"
                        memory = "1024Mi"
                    }
                }
            }
        }
    }
}

# resource "google_composer_environment" "anp_composer" {
#     name   = "anp-composer"
#     region = var.region
#     project = var.project_id

#     config {
#         node_config {
#             service_account = var.service_account_email
#         }
#         software_config {
#             image_version = "composer-3-airflow-2.10.5-build.8"
#             pypi_packages = {
#                 "apache-airflow-providers-google" = ""
#                 "apache-airflow-providers-http" = ""
#                 "apache-airflow-providers-ftp" = ""
#             }
#         }
#     }
# }
