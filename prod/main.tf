variable "environment" {
  description = "Environment name"
  type        = string
  default     = "terraform-prod"
}

resource "aws_security_group" "api" {
  name   = "${var.environment}-api"
  vpc_id = data.aws_vpc.this.id
}

resource "aws_security_group" "redis" {
  name   = "${var.environment}-redis"
  vpc_id = data.aws_vpc.this.id
}

resource "aws_security_group_rule" "allow_api_6379_to_redis" {
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  type                     = "ingress"
  security_group_id        = aws_security_group.redis.id
  source_security_group_id = aws_security_group.api.id
}

provider "aws" {
  region = "us-east-1"
}

variable "vpc_name" {
  description = "Name of the VPC"
  type = string
  default = "ami-vpc"
}

data "aws_vpc" "this" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}
