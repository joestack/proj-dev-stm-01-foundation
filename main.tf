### main.tf ###

terraform {
  required_version = ">= 0.12"
}

provider "aws" {
    region = var.aws_region
}

data "aws_availability_zones" "available" {}


# VPC 

resource "aws_vpc" "hashicorp_vpc" {
  cidr_block           = var.network_address_space
  enable_dns_hostnames = "true"

  tags = {
    Name        = "${var.name}-vpc"
  }
}

# Internet Gateways and route table

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.hashicorp_vpc.id
}

resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.hashicorp_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "${var.name}-igw"
  }
}

# subnet public

resource "aws_subnet" "dmz_subnet" {
  vpc_id                  = aws_vpc.hashicorp_vpc.id
  cidr_block              = cidrsubnet(var.network_address_space, 8, 1)
  map_public_ip_on_launch = "true"
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name        = "dmz-subnet"
  }
}

# public subnet to IGW

resource "aws_route_table_association" "dmz-subnet" {
  subnet_id      = aws_subnet.dmz_subnet.*.id[0]
  route_table_id = aws_route_table.rtb.id
}

# DNS

data "aws_route53_zone" "selected" {
  name         = "${var.dns_domain}."
  private_zone = false
}


output "vpc_id" {
  value = aws_vpc.hashicorp_vpc.id
}

output "dns_zone_id" {
  value = aws_route53_zone.selected.zone_id
}

