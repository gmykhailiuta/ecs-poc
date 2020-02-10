# ECS Cluster

resource "aws_ecs_cluster" "app" {
  name = "app"
  tags = {
    Name = "app"
    environment = var.environment
  }
}

# ECS Task Definition

data "aws_iam_policy_document" "app-ecs-task-assume-role-policy" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["ecs-tasks.amazonaws.com"]
      type = "Service"
    }
  }
}

resource "aws_iam_role" "ecs-task-execution-role" {
  name = "ecs-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.app-ecs-task-assume-role-policy.json
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy" {
  role = aws_iam_role.ecs-task-execution-role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "ecs-task-role-policy" {
  statement {
    effect = "Allow"
    actions = [
        "s3:*"
    ]
    resources = [ "*" ]
  }
}

resource "aws_iam_role" "ecs-task-role" {
  name = "ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.app-ecs-task-assume-role-policy.json
}

resource "aws_iam_role_policy" "ecs-task-role-policy" {
  name   = "ecs-task-role-policy"
  role   = aws_iam_role.ecs-task-role.id
  policy = data.aws_iam_policy_document.ecs-task-role-policy.json
}

data "template_file" "task_definition" {
  template = "${file("templates/app-task-definition.json")}"

  vars = {
    image_url        = "${var.account_id}.dkr.ecr.${var.region}.amazonaws.com/app:latest"
    container_name   = "app"
    # Application should definitely use own postgres role with limited rights to access database
    # Using superuser role here intentionally for simplification
    database_uri     = "postgresql://postgres:pKw6mUpR7N6jbNsZ3AQVNnCe@${aws_db_instance.db01.endpoint}/postgres"
    log_group_region = "${var.region}"
    log_group_name   = "${aws_cloudwatch_log_group.app.name}"
  }
}

resource "aws_ecs_task_definition" "app" {
  family                = "app"
  container_definitions = "${data.template_file.task_definition.rendered}"
  task_role_arn = "${aws_iam_role.ecs-task-role.arn}"
  execution_role_arn = "${aws_iam_role.ecs-task-execution-role.arn}"
  tags = {
    Name = "app"
    environment = var.environment
  }
}

resource "aws_cloudwatch_log_group" "app" {
  name = "/ecs/app"
  retention_in_days = 1
}

# ECS Service
data "aws_iam_policy_document" "app-ecs-service-assume-role-policy" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["ecs.amazonaws.com"]
      type = "Service"
    }
  }
}

resource "aws_iam_role" "ecs-service-role" {
  name = "ecs-service-role"
  assume_role_policy = data.aws_iam_policy_document.app-ecs-service-assume-role-policy.json
}

resource "aws_iam_role_policy_attachment" "ecs-service-role-policy" {
  role = aws_iam_role.ecs-service-role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

resource "aws_ecs_service" "app" {
  name            = "app"
  cluster         = "${aws_ecs_cluster.app.id}"
  task_definition = "${aws_ecs_task_definition.app.arn}"
  desired_count   = 2
  iam_role        = "${aws_iam_role.ecs-service-role.arn}"
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent = 200
  health_check_grace_period_seconds = 5
  launch_type     = "EC2"
  load_balancer {
    target_group_arn = "${aws_lb_target_group.app-lb-tg.arn}"
    container_name   = "app"
    container_port   = 8000
  }
  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }
  depends_on = [
    "aws_lb_listener.app-lb-lnr",
    "aws_lb_target_group.app-lb-tg"
  ]
}
