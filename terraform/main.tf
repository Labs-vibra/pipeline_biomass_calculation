
resource "google_storage_bucket" "anp_bucket_etl" {
  name     = "anp-ext-bucket-etl"
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
                image = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.anp_repo_etl.repository_id}/run-notebook-api:latest"
                env {
                    name  = "NOTEBOOK_TO_BE_EXECUTED"
                    value = "gs://${google_storage_bucket.anp_bucket_etl.name}/notebooks/rw_ext_anp_b100_sales.ipynb"
                }
                resources {
                    limits = {
                        cpu    = "2"
                        memory = "1024Mi"
                    }
                }
            }
            service_account = var.service_account_email
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
                    name  = "NOTEBOOK_TO_BE_EXECUTED"
                    value = "gs://${google_storage_bucket.anp_bucket_etl.name}/notebooks/rw_ext_anp_b100_sales.ipynb"
                }
                resources {
                    limits = {
                        cpu    = "2"
                        memory = "1024Mi"
                    }
                }
            }
            service_account = var.service_account_email
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
                    name  = "NOTEBOOK_TO_BE_EXECUTED"
                    value = "gs://${google_storage_bucket.anp_bucket_etl.name}/notebooks/rw_ext_anp_congeneres_sales.ipynb"
                }
                resources {
                    limits = {
                        cpu    = "2"
                        memory = "1024Mi"
                    }
                }
            }
            service_account = var.service_account_email
        }
    }
}

