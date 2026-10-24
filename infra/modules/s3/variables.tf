variable "bucket_name" {
  description = "Pełna nazwa bucketa."
  type        = string
}

variable "force_destroy" {
  description = "Kasuje bucket razem z obiektami."
  type        = bool
}

variable "project" {
  description = "Tag projektu."
  type        = string
}

variable "environment" {
  description = "Tag środowiska."
  type        = string
}
