resource "aws_lb" "load-balancer-ui" {
  name               = "load-balancer-ui"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.main_security_group.id]
  subnets            = [aws_subnet.public-subnet-a.id, aws_subnet.public-subnet-b.id]

  enable_deletion_protection = true

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "lb-listenner-ui" {
  load_balancer_arn = aws_lb.load-balancer-ui.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb-target-group-ui.arn
  }
}

resource "aws_lb_target_group" "lb-target-group-ui" {
  name     = "lb-target-group-ui"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_ecs_task_definition" "service-hello-ui" {
  family = "service-hello-ui"
  container_definitions = jsonencode([
    {
      name      = "hello-ui-container"
      image     = "${aws_ecr_repository.hello-ui.repository_url}:latest"
      cpu       = 128
      memory    = 128
      essential = true
      environment= [
        {name="MICROSERVICE_URL", value="http://${aws_lb.load-balancer-ms.dns_name}"}
      ]
      portMappings = [
        {
          containerPort = 5000
          hostPort      = 0
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "service-ecs-hello-ui" {
  name            = "hello-ui"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.service-hello-ui.arn
  desired_count   = 1
  iam_role        = var.lab_role

  load_balancer {
    target_group_arn = aws_lb_target_group.lb-target-group-ui.arn
    container_name   = "hello-ui-container"
    container_port   = 5000
  }

  

}

