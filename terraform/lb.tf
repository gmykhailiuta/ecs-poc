resource "aws_lb" "app-lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.lb-sg.id}"]
  subnets = [
    aws_subnet.lb-a.id,
    aws_subnet.lb-b.id,
    aws_subnet.lb-c.id
  ]
  enable_deletion_protection = false
  access_logs {
    bucket  = "${aws_s3_bucket.lb-logs-bucket.bucket}"
    prefix  = "app-lb"
    enabled = true
  }
  depends_on = [
    aws_internet_gateway.main,
  ]
  tags = {
    Name = "app-lb"
    env = var.environment
  }
}

resource "aws_lb_target_group" "app-lb-tg" {
  name     = "app-lb-tg-${random_integer.app-target-group-id.result}"
  protocol = "${random_integer.app-target-group-id.keepers.protocol}"
  port     = "${random_integer.app-target-group-id.keepers.port}"
  vpc_id   = "${aws_vpc.main.id}"
  deregistration_delay = 30

  health_check {
    enabled = true
    interval = 10
    path = "/healthcheck"
    protocol = "HTTP"
    timeout = 5
  }
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "app-lb-tg"
    env = var.environment
  }
}

resource "aws_lb_listener" "app-lb-lnr" {
  load_balancer_arn = "${aws_lb.app-lb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.app-lb-tg.arn}"
  }
  depends_on = ["aws_lb_target_group.app-lb-tg"]
}


resource "random_integer" "app-target-group-id" {
  min = 1
  max = 999

  keepers = {
    port        = "80"
    protocol    = "HTTP"
    vpc_id      = "${aws_vpc.main.id}"
  }
}

resource "aws_security_group" "lb-sg" {
  name        = "lb-sg"
  description = "Allow LB traffic"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
  tags = {
    Name = "lb-sg"
    environment = var.environment
  }
}
