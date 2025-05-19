resource "aws_ecs_cluster" "alert_cluster" {
  name = "alert-receiver-cluster"
}

# Placeholder for VPC 
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}
