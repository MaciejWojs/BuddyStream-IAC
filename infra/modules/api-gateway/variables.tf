variable "name" {
  description = "Nazwa REST API i web ACL."
  type        = string
}

variable "stage_name" {
  description = "Nazwa stage, np. local albo dev."
  type        = string
}

variable "backend_base_url" {
  description = "Adres usługi aplikacyjnej, bez końcowego ukośnika. Floci woła go z kontenera, więc localhost bramy to nie host."
  type        = string

  validation {
    condition     = startswith(var.backend_base_url, "http://") || startswith(var.backend_base_url, "https://")
    error_message = "backend_base_url musi zaczynać się od http:// albo https://."
  }
}

variable "cors_allow_origin" {
  description = "Wartość Access-Control-Allow-Origin na preflight OPTIONS."
  type        = string
  default     = "*"
}

variable "rate_limit" {
  description = "Limit żądań na adres w oknie WAF. Na AWS minimum to 10. Floci reguły nie egzekwuje."
  type        = number
  default     = 2000
}

variable "project" {
  description = "Tag projektu."
  type        = string
}

variable "environment" {
  description = "Tag środowiska."
  type        = string
}

variable "domain_name" {
  description = "Własna domena bramy, np. api.localhost.floci.io. Puste = tylko adres execute-api."
  type        = string
  default     = null
}

variable "regional_certificate_arn" {
  description = "ARN certyfikatu regionalnego. We Floci składnia wystarczy, na AWS to certyfikat ACM z tego regionu."
  type        = string
  default     = null
}
