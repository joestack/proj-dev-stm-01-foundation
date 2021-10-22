variable "aws_region" {
  description = "AWS region"
  default     = "eu-west-1"
}

variable "name" {
  description = "Unique name of the deployment"
}

variable "dns_domain" {
  description = "DNS domain suffix"
  default     = "joestack.xyz"
}

variable "network_address_space" {
  description = "CIDR for this deployment"
  default     = "192.168.0.0/16"
}

