/******************* ALB Target Group: Integration,config,logging,s2s ****************/
resource "aws_alb_target_group" "integration" {
  name        = "${var.project.name}-${terraform.workspace}-integration-tg"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.selected.id
  tags        = var.default_tags
  health_check {
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    interval            = "120"
    matcher             = "200"
    path                = var.ecs_integration.health_check_path
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
  }
}

resource "aws_alb_target_group" "config" {
  name        = "${var.project.name}-${terraform.workspace}-config-tg"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.selected.id
  tags        = var.default_tags
  health_check {
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    interval            = "120"
    matcher             = "200"
    path                = var.ecs_config.health_check_path
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
  }
}

resource "aws_alb_target_group" "logging" {
  name        = "${var.project.name}-${terraform.workspace}-logging-tg"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.selected.id
  tags        = var.default_tags
  health_check {
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    interval            = "120"
    matcher             = "200"
    path                = var.ecs_logging.health_check_path
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
  }
}

resource "aws_alb_target_group" "s2s" {
  name        = "${var.project.name}-${terraform.workspace}-s2s-tg"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.selected.id
  tags        = var.default_tags
  health_check {
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    interval            = "120"
    matcher             = "200"
    path                = var.ecs_s2s.health_check_path
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
  }
}

/*********** Cloudwatch Log Group: ****************/
resource "aws_cloudwatch_log_group" "group" {
  name              = "${var.project.name}-${terraform.workspace}"
  retention_in_days = 90
  tags              = var.default_tags
}

/*********** IAM Role: Taskdefinition ****************/
resource "aws_iam_role" "iam_for_task_definition" {
  name = "${var.project.name}-${terraform.workspace}-ecs-execution-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ecs-tasks.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

/*********** Task Definition: Integration ****************/
data "template_file" "integration" {
  template = file("${path.module}/data/task-definition.json")
  vars = {
    container_name    = "${var.project.name}-${terraform.workspace}-integration"
    container_port    = 8080
    log_group_region  = var.aws.region
    log_group_name    = aws_cloudwatch_log_group.group.name
    log_stream_prefix = "ecs/integration"
    family            = "${var.project.name}-${terraform.workspace}-integration"
  }
}

resource "aws_ecs_task_definition" "integration" {
  family                   = "${var.project.name}-${terraform.workspace}-integration"
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = "arn:aws:iam::${var.aws.account_id}:role/${var.project.name}-${terraform.workspace}-ecs-execution-role"
  execution_role_arn       = "arn:aws:iam::${var.aws.account_id}:role/${var.project.name}-${terraform.workspace}-ecs-execution-role"
  container_definitions    = data.template_file.integration.rendered
  tags                     = var.default_tags
}

/*********** Task Definition: Config ****************/
data "template_file" "config" {
  template = file("${path.module}/data/task-definition.json")
  vars = {
    container_name    = "${var.project.name}-${terraform.workspace}-config"
    container_port    = 8080
    log_group_region  = var.aws.region
    log_group_name    = aws_cloudwatch_log_group.group.name
    log_stream_prefix = "ecs/config"
    family            = "${var.project.name}-${terraform.workspace}-config"
  }
}

resource "aws_ecs_task_definition" "config" {
  family                   = "${var.project.name}-${terraform.workspace}-config"
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = "arn:aws:iam::${var.aws.account_id}:role/${var.project.name}-${terraform.workspace}-ecs-execution-role"
  execution_role_arn       = "arn:aws:iam::${var.aws.account_id}:role/${var.project.name}-${terraform.workspace}-ecs-execution-role"
  container_definitions    = data.template_file.config.rendered
  tags                     = var.default_tags
}

/*********** Task Definition: Logging ****************/
data "template_file" "logging" {
  template = file("${path.module}/data/task-definition.json")
  vars = {
    container_name    = "${var.project.name}-${terraform.workspace}-logging"
    container_port    = 8080
    log_group_region  = var.aws.region
    log_group_name    = aws_cloudwatch_log_group.group.name
    log_stream_prefix = "ecs/logging"
    family            = "${var.project.name}-${terraform.workspace}-logging"
  }
}

resource "aws_ecs_task_definition" "logging" {
  family                   = "${var.project.name}-${terraform.workspace}-logging"
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = "arn:aws:iam::${var.aws.account_id}:role/${var.project.name}-${terraform.workspace}-ecs-execution-role"
  execution_role_arn       = "arn:aws:iam::${var.aws.account_id}:role/${var.project.name}-${terraform.workspace}-ecs-execution-role"
  container_definitions    = data.template_file.logging.rendered
  tags                     = var.default_tags
}

/*********** Task Definition: S2S ****************/
data "template_file" "s2s" {
  template = file("${path.module}/data/task-definition.json")
  vars = {
    container_name    = "${var.project.name}-${terraform.workspace}-s2s"
    container_port    = 8080
    log_group_region  = var.aws.region
    log_group_name    = aws_cloudwatch_log_group.group.name
    log_stream_prefix = "ecs/s2s"
    family            = "${var.project.name}-${terraform.workspace}-s2s"
  }
}

resource "aws_ecs_task_definition" "s2s" {
  family                   = "${var.project.name}-${terraform.workspace}-s2s"
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = "arn:aws:iam::${var.aws.account_id}:role/${var.project.name}-${terraform.workspace}-ecs-execution-role"
  execution_role_arn       = "arn:aws:iam::${var.aws.account_id}:role/${var.project.name}-${terraform.workspace}-ecs-execution-role"
  container_definitions    = data.template_file.s2s.rendered
  tags                     = var.default_tags
}

/*********** Security Group: Integration ****************/
resource "aws_security_group" "integration" {
  name        = "${var.project.name}-${terraform.workspace}-integration-ecs-sg"
  description = "${var.project.name}-${terraform.workspace}-integration-ecs-sg"
  vpc_id      = var.aws.vpc_id
  tags        = var.default_tags

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.microservices.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

/*********** Security Group: Config ****************/
resource "aws_security_group" "config" {
  name        = "${var.project.name}-${terraform.workspace}-config-ecs-sg"
  description = "${var.project.name}-${terraform.workspace}-config-ecs-sg"
  vpc_id      = var.aws.vpc_id
  tags        = var.default_tags
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.microservices.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

/*********** Security Group: Logging ****************/
resource "aws_security_group" "logging" {
  name        = "${var.project.name}-${terraform.workspace}-logging-ecs-sg"
  description = "${var.project.name}-${terraform.workspace}-logging-ecs-sg"
  vpc_id      = var.aws.vpc_id
  tags        = var.default_tags
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.microservices.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

/*********** Security Group: S2S ****************/
resource "aws_security_group" "s2s" {
  name        = "${var.project.name}-${terraform.workspace}-s2s-ecs-sg"
  description = "${var.project.name}-${terraform.workspace}-s2s-ecs-sg"
  vpc_id      = var.aws.vpc_id
  tags        = var.default_tags
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.microservices.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


/*********** ECS Cluster ****************/
resource "aws_ecs_cluster" "microservices-cluster" {
  name = "${var.project.name}-${terraform.workspace}-microservices-cluster"
  tags = var.default_tags
}


/*********** Security Group: Microservices ALB ****************/
resource "aws_security_group" "microservices" {
  name        = "${var.project.name}-${terraform.workspace}-microservices-alb-sg"
  description = "${var.project.name}-${terraform.workspace}-microservices-alb-sg"
  vpc_id      = var.aws.vpc_id
  tags        = var.default_tags

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

/*********** Load Balancer: Microservices LB ****************/
resource "aws_lb" "microservices" {
  name                       = "${var.project.name}-${terraform.workspace}-microservices-lb"
  internal                   = true
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.microservices.id]
  subnets                    = [var.ecs.subnet1, var.ecs.subnet2]
  enable_deletion_protection = true
  tags                       = var.default_tags
}

/*********** Load Balancer Listener: Microservices ****************/
resource "aws_lb_listener" "microservices" {
  load_balancer_arn = aws_lb.microservices.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-FS-1-2-Res-2020-10"
  certificate_arn   = "arn:aws:acm:ap-south-1:${var.aws.account_id}:${var.ecs.listener_certificate_arn}"
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.integration.arn
  }
}

/*********** Listener Rule: Integration Service ****************/
resource "aws_alb_listener_rule" "integration" {
  listener_arn = aws_lb_listener.microservices.arn
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.integration.arn
  }
  condition {
    path_pattern {
      values = [var.ecs_integration.path_pattern]
    }
  }
}

/*********** Listener Rule: Config Service ****************/
resource "aws_alb_listener_rule" "config" {
  listener_arn = aws_lb_listener.microservices.arn
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.config.arn
  }
  condition {
    path_pattern {
      values = [var.ecs_config.path_pattern]
    }
  }
}

/*********** Listener Rule: Logging Service ****************/
resource "aws_alb_listener_rule" "logging" {
  listener_arn = aws_lb_listener.microservices.arn
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.logging.arn
  }
  condition {
    path_pattern {
      values = [var.ecs_logging.path_pattern]
    }
  }
}

/*********** Listener Rule: S2S Service ****************/
resource "aws_alb_listener_rule" "s2s" {
  listener_arn = aws_lb_listener.microservices.arn
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.s2s.arn
  }
  condition {
    path_pattern {
      values = [var.ecs_s2s.path_pattern]
    }
  }
}

/*********** ECS Service: Integration ****************/
resource "aws_ecs_service" "integration" {
  name            = "${var.project.name}-${terraform.workspace}-integration-service"
  cluster         = aws_ecs_cluster.microservices-cluster.id
  task_definition = aws_ecs_task_definition.integration.arn
  desired_count   = 1
  depends_on      = [aws_lb.microservices]
  launch_type     = "FARGATE"
  load_balancer {
    target_group_arn = aws_alb_target_group.integration.arn
    container_port   = 8080
    container_name   = "${var.project.name}-${terraform.workspace}-integration"
  }
  network_configuration {
    security_groups = ["${aws_security_group.integration.id}"]
    subnets         = [var.ecs.subnet1, var.ecs.subnet2]
  }
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  tags                               = var.default_tags
}

/*********** ECS Service: Config ****************/
resource "aws_ecs_service" "config" {
  name            = "${var.project.name}-${terraform.workspace}-config-service"
  cluster         = aws_ecs_cluster.microservices-cluster.id
  task_definition = aws_ecs_task_definition.config.arn
  desired_count   = 1
  depends_on      = [aws_lb.microservices]
  launch_type     = "FARGATE"
  load_balancer {
    target_group_arn = aws_alb_target_group.config.arn
    container_port   = 8080
    container_name   = "${var.project.name}-${terraform.workspace}-config"
  }
  network_configuration {
    security_groups = ["${aws_security_group.config.id}"]
    subnets         = [var.ecs.subnet1, var.ecs.subnet2]
  }
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  tags                               = var.default_tags
}

/*********** ECS Service: Logging ****************/
resource "aws_ecs_service" "logging" {
  name            = "${var.project.name}-${terraform.workspace}-logging-service"
  cluster         = aws_ecs_cluster.microservices-cluster.id
  task_definition = aws_ecs_task_definition.logging.arn
  desired_count   = 1
  depends_on      = [aws_lb.microservices]
  launch_type     = "FARGATE"
  load_balancer {
    target_group_arn = aws_alb_target_group.logging.arn
    container_port   = 8080
    container_name   = "${var.project.name}-${terraform.workspace}-logging"
  }
  network_configuration {
    security_groups = ["${aws_security_group.logging.id}"]
    subnets         = [var.ecs.subnet1, var.ecs.subnet2]
  }
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  tags                               = var.default_tags
}

/*********** ECS Service: S2s ****************/
resource "aws_ecs_service" "s2s" {
  name            = "${var.project.name}-${terraform.workspace}-s2s-service"
  cluster         = aws_ecs_cluster.microservices-cluster.id
  task_definition = aws_ecs_task_definition.s2s.arn
  desired_count   = 1
  depends_on      = [aws_lb.microservices]
  launch_type     = "FARGATE"
  load_balancer {
    target_group_arn = aws_alb_target_group.s2s.arn
    container_port   = 8080
    container_name   = "${var.project.name}-${terraform.workspace}-s2s"
  }
  network_configuration {
    security_groups = ["${aws_security_group.s2s.id}"]
    subnets         = [var.ecs.subnet1, var.ecs.subnet2]
  }
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  tags                               = var.default_tags
}


/*********** IAM Role Policy: ECS Task Definition ****************/
resource "aws_iam_role_policy_attachment" "cloudwatch-logs-policy" {
  policy_arn = "arn:aws:iam::${var.aws.account_id}:policy/cloudwatch-logs-policy"
  role       = aws_iam_role.iam_for_task_definition.id
}

resource "aws_iam_role_policy_attachment" "ecr-pull-image-access-policy" {
  policy_arn = "arn:aws:iam::${var.aws.account_id}:policy/ECR-Pull-image-access-policy"
  role       = aws_iam_role.iam_for_task_definition.id
}

resource "aws_iam_role_policy_attachment" "Custom_ECSTaskExecutionRolePolicy" {
  policy_arn = "arn:aws:iam::${var.aws.account_id}:policy/Custom_ECSTaskExecutionRolePolicy"
  role       = aws_iam_role.iam_for_task_definition.id
}
