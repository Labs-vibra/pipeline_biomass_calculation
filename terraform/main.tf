resource "google_storage_bucket" "teste_bucket" {
  name     = "anp-bucket-etl"
  location = var.region
  force_destroy = true
}

resource "google_artifact_registry_repository" "teste_repo" {
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
                ports {
                    container_port = 8080
                }
                env {
                    name  = "NOTEBOOK_GCS_URI"
                    value = "gs://${google_storage_bucket.teste_bucket.name}/notebooks/rw_ext_anp_b100_sales.ipynb"
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
                ports {
                    container_port = 8080
                }
                env {
                    name  = "NOTEBOOK_GCS_URI"
                    value = "gs://${google_storage_bucket.teste_bucket.name}/notebooks/rw_ext_anp_b100_sales.ipynb"
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
