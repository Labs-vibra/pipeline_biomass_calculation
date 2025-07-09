variable "project_id" {
  description = "ID do projeto GCP"
  type        = string
  default     = "named-embassy-456813-f3"
}

variable "region" {
  description = "Região do GCP"
  type        = string
  default     = "us-central1"
}

variable "service_account_email" {
  description = "Email da conta de serviço para autenticação"
  type        = string
  default     = "labs-vibra-dev@named-embassy-456813-f3.iam.gserviceaccount.com"
}