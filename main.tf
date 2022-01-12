terraform {
  cloud {
    organization = "693051501776_brynardsecurity-aws"

    workspaces {
      name = "development"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "us-east-2"
  region = "us-east-2"
}

provider "aws" {
  alias  = "us-west-1"
  region = "us-west-1"
}

provider "aws" {
  alias  = "us-west-2"
  region = "us-west-2"
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  cidr_c_private_subnets = 1
  cidr_c_public_subnets  = 11

  max_private_subnets = 3
  max_public_subnets  = 3

  availability_zones = data.aws_availability_zones.available.names

  private_subnets = [
    for az in local.availability_zones :
    "${lookup(var.cidr_ab, var.environment)}.${local.cidr_c_private_subnets + index(local.availability_zones, az)}.0/24"
    if index(local.availability_zones, az) < local.max_private_subnets
  ]
  public_subnets = [
    for az in local.availability_zones :
    "${lookup(var.cidr_ab, var.environment)}.${local.cidr_c_public_subnets + index(local.availability_zones, az)}.0/24"
    if index(local.availability_zones, az) < local.max_public_subnets
  ]
  name         = "${var.account_id}-${var.environment}"
  build_date   = formatdate("YYYY-MM-DD", timestamp())
  build_branch = var.build_branch
  region       = var.aws_region
  tags = {
    AccountID    = var.account_id
    AccountAlias = var.account_id_alias
    Environment  = var.environment
    Name         = "${var.account_id}-${var.aws_region}-${var.environment}"
    BuildBranch  = var.build_branch
    BuildRepo    = var.build_repo
    DeployDate   = local.build_date
    Owner        = var.owner
    Contact      = var.contact
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.11.0"

  providers = {
    aws = aws.us-east-2
  }

  name = local.name
  cidr = "${lookup(var.cidr_ab, var.environment)}.0.0/16"

  azs             = local.availability_zones
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = false
  single_nat_gateway = false

  enable_vpn_gateway  = false
  enable_dhcp_options = false

  manage_default_security_group  = false
  default_security_group_ingress = []
  default_security_group_egress  = []
}