variable "environment" {
  description = "Nazwa środowiska, np. local, dev, prod. Podmienia się przez -var-file."
  type        = string
}

variable "project" {
  description = "Prefiks nazwy zasobów."
  type        = string
  default     = "platforma"
}

variable "aws_region" {
  description = "Region AWS. We Floci wartość jest tylko etykietą."
  type        = string
  default     = "eu-central-1"
}

variable "bucket_name" {
  description = "Pełna nazwa bucketa. Puste = project-environment."
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "Pozwala skasować bucket razem z obiektami. Włączone tylko na local."
  type        = bool
  default     = false
}

variable "aws_s3_endpoint" {
  description = "Własny endpoint S3. Null = prawdziwe AWS."
  type        = string
  default     = null
}

variable "s3_use_path_style" {
  description = "Path-style URL. Wymagane przez Floci na localhost:4566."
  type        = bool
  default     = false
}

variable "skip_aws_checks" {
  description = "Pomija walidację konta i credentiali. Włączone tylko na local."
  type        = bool
  default     = false
}

variable "aws_access_key" {
  description = "Klucz AWS. Null = domyślny łańcuch credentiali (profil, zmienne, rola)."
  type        = string
  default     = null
  sensitive   = true
}

variable "aws_secret_key" {
  description = "Sekret AWS. Null = domyślny łańcuch credentiali."
  type        = string
  default     = null
  sensitive   = true
}

variable "enable_eks" {
  description = "Tworzy klaster EKS. Na local Floci stawia kontener k3s. Wyłączone na prawdziwym AWS."
  type        = bool
  default     = false
}

variable "kubernetes_version" {
  description = "Wersja Kubernetesa klastra EKS."
  type        = string
  default     = "1.31"
}

variable "enable_api_gateway" {
  description = "Tworzy REST API Gateway i web ACL WAF. We Floci brama przekazuje ruch, a reguły WAF nie filtrują żądań."
  type        = bool
  default     = false
}

variable "api_gateway_backend_url" {
  description = "Adres usługi aplikacyjnej dla integracji HTTP_PROXY. Wymagany, gdy enable_api_gateway = true. Z kontenera Floci host to zwykle http://host.docker.internal:3000."
  type        = string
  default     = null
}
