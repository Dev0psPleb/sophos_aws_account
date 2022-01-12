variable "cidr_ab" {
  type = map(any)
  default = {
    dev   = "11.4"
    stage = "11.3"
    qa    = "11.2"
    prod  = "11.1"
  }
}
variable "environment" {
  type        = string
  description = "Options: dev, stage, qa, prod"
  default     = "dev"
}
variable "aws_default_region" {
  default = ""
}
variable "account_id" {
  description = "The AWS Account ID."
  default     = ""
}
variable "account_id_alias" {
  description = "AWS Account alias."
  default     = ""
}
variable "customer_gateway_ip" {
  description = "IP address of the customer gateway."
  default     = ""
}
variable "device_name" {
  description = "Customer gateway device name."
  default     = ""
}
variable "build_branch" {
  default = "production"
}
variable "build_repo" {
  default = "aws"
}
variable "aws_region" {
  default = "us-east-2"
}