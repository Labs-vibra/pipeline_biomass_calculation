
resource "google_storage_bucket" "anp_bucket_etl" {
  name     = "vibra-dtan-juridico-anp-input"
  location = var.region
}

resource "google_artifact_registry_repository" "anp_repo_etl" {
    repository_id     = "ar-juridico-process-notebooks"
    location = var.region
    format   = "DOCKER"

    description = "Repositório de artefatos para o projeto ANP"
    project  = var.project_id
}

resource "google_cloud_run_v2_job" "anp_vendas_b100_job" {
    name     = "cr-juridico-etl-venda-b100-dev"
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
    depends_on = [google_storage_bucket.anp_bucket_etl, google_artifact_registry_repository.anp_repo_etl]
}

resource "google_cloud_run_v2_job" "anp_vendas_total_job" {
    name     = "cr-juridico-etl-venda-total-dev"
    location = var.region
    project  = var.project_id
    template {
        template {
            containers {
                image = "${var.region}-docker.pkg.dev/${var.project_id}/anp-repo-etl/run-notebook-api:latest"
                env {
                    name  = "NOTEBOOK_TO_BE_EXECUTED"
                    value = "gs://${google_storage_bucket.anp_bucket_etl.name}/notebooks/rw_ext_anp_total_sales.ipynb"
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
    depends_on = [google_storage_bucket.anp_bucket_etl, google_artifact_registry_repository.anp_repo_etl]
}

resource "google_cloud_run_v2_job" "anp_vendas_congeneres" {
    name     = "cr-juridico-etl-venda-congeneres-dev"
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
    depends_on = [google_storage_bucket.anp_bucket_etl, google_artifact_registry_repository.anp_repo_etl]
}

resource "google_cloud_run_v2_job" "anp_grupos_empresariais" {
    name     = "cr-juridico-process-grupos-empresariais-dev"
    location = var.region
    project  = var.project_id
    template {
        template {
            containers {
                image = "${var.region}-docker.pkg.dev/${var.project_id}/anp-repo-etl/run-notebook-api:latest"
                env {
                    name  = "NOTEBOOK_TO_BE_EXECUTED"
                    value = "gs://${google_storage_bucket.anp_bucket_etl.name}/notebooks/rf_ext_anp_empresarial_groups.ipynb"
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
    depends_on = [google_storage_bucket.anp_bucket_etl, google_artifact_registry_repository.anp_repo_etl]
}

resource "google_cloud_run_v2_job" "anp_agentes_regulados_simp" {
    name     = "cr-juridico-etl-agentes-regulados-simp-dev"
    location = var.region
    project  = var.project_id
    template {
        template {
            containers {
                image = "${var.region}-docker.pkg.dev/${var.project_id}/anp-repo-etl/run-notebook-api:latest"
                env {
                    name  = "NOTEBOOK_TO_BE_EXECUTED"
                    value = "gs://${google_storage_bucket.anp_bucket_etl.name}/notebooks/rw_ext_anp_regulatory_agents_simplified.ipynb"
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
    depends_on = [google_storage_bucket.anp_bucket_etl, google_artifact_registry_repository.anp_repo_etl]
}