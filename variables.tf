variable "region" {
  description = "Region donde se desplegaran los recursos"
  default = "us-east-1"
  type = string
}

variable "vpc_cidr_block" {
  description = "CIDR block de la vpc"
  default = "10.0.0.0/16"
  type = string
}

variable "public_subnet_a_cidr" {
    description = "CIDR block del public subnet a"
    default = "10.0.1.0/24"
    type = string
}

variable "public_subnet_b_cidr" {
    description = "CIDR block del public subnet b"
    default = "10.0.2.0/24"
    type = string
}

variable "private_subnet_a_cidr" {
    description = "CIDR block del private subnet a"
    default = "10.0.3.0/24"
    type = string
}

variable "private_subnet_b_cidr" {
    description = "CIDR block del private subnet b"
    default = "10.0.4.0/24"
    type = string
}