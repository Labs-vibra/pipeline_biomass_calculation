variable "project_id" {
  description = "ID do projeto GCP"
  type        = string
  default     = "labs-vibra-final"
}

variable "region" {
  description = "Região do GCP"
  type        = string
  default     = "us-central1"
}

variable "service_account_email" {
  description = "Email da conta de serviço para autenticação"
  type        = string
  default     = "gcp-agent@labs-vibra-final.iam.gserviceaccount.com"
}