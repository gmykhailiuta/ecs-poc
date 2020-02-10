# ECS EC2 instance
data "aws_ssm_parameter" "amazon-linux-ecs-ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

resource "aws_instance" "app-ecs-instance" {
  ami = data.aws_ssm_parameter.amazon-linux-ecs-ami.value
  instance_type = "t3.micro"
  subnet_id = "${aws_subnet.apps-a.id}"
  vpc_security_group_ids = [
    "${aws_security_group.app-sg.id}",
    "${aws_security_group.default-sg.id}"
  ]
  user_data = data.template_file.user_data.rendered
  disable_api_termination = false
  associate_public_ip_address = true
  key_name = aws_key_pair.deployer-key.id
  iam_instance_profile = aws_iam_instance_profile.app-ecs-instance-profile.id
  root_block_device {
    volume_type = "gp2"
    volume_size = "30"
  }
  tags = {
    Name = "app-ecs-instance"
    env = var.environment
  }
}

data "template_file" "user_data" {
  template = file("templates/user-data.sh")

  vars = {
    cluster_name = aws_ecs_cluster.app.name
  }
}

# ECS EC2 instance profile
data "aws_iam_policy_document" "app-ecs-instance-role-assume-policy" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["ec2.amazonaws.com"]
      type = "Service"
    }
  }
}

resource "aws_iam_role" "app-ecs-instance-role" {
  name = "app-ecs-instance-role"
  path = "/ecs/"
  assume_role_policy = data.aws_iam_policy_document.app-ecs-instance-role-assume-policy.json
}

resource "aws_iam_instance_profile" "app-ecs-instance-profile" {
  name = "app-ecs-instance-profile"
  role = aws_iam_role.app-ecs-instance-role.name
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_role" {
  role = aws_iam_role.app-ecs-instance-role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_cloudwatch_role" {
  role = aws_iam_role.app-ecs-instance-role.id
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

# ECS EC2 instance security group
resource "aws_security_group" "app-sg" {
  name        = "app-sg"
  description = "App"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 1000
    to_port     = 65535
    protocol    = "tcp"
    security_groups = [
      "${aws_security_group.lb-sg.id}"
    ]
  }

  tags = {
    Name = "app-sg"
    environment = var.environment
  }
}
