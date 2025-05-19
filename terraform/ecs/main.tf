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

resource "aws_ecs_task_definition" "alert_receiver" {
  family                   = "alert-receiver-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name  = "alert-receiver"
      image = "${aws_ecr_repository.alert_receiver.repository_url}:latest"
      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
        }
      ]
      essential = true
    }
  ])
}
