variable "cluster_name" {
  description = "Nazwa klastra EKS. DeleteCluster kasuje cały klaster razem z tym, co w nim jest."
  type        = string
}

variable "kubernetes_version" {
  description = "Wersja Kubernetesa. We Floci mapuje się na przypięty obraz k3s."
  type        = string
}

variable "aws_region" {
  description = "Region. We Floci tylko etykieta, z niej biorą się nazwy stref."
  type        = string
}

variable "project" {
  description = "Tag projektu."
  type        = string
}

variable "environment" {
  description = "Tag środowiska."
  type        = string
}
