resource "aws_vpc" "main" {
  cidr_block = "10.254.0.0/16"
  # Required for RDS public access
  enable_dns_hostnames = "true"
  enable_dns_support = "true"
  tags = {
    Name = "main"
    environment  = var.environment
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main"
    environment  = var.environment
  }
}

resource "aws_nat_gateway" "nat-a" {
  allocation_id = "${aws_eip.nat-a.id}"
  subnet_id = "${aws_subnet.nat-a.id}"
  depends_on = ["aws_internet_gateway.main"]
  tags = {
    Name = "nat-a"
    environment  = var.environment
  }
}

resource "aws_nat_gateway" "nat-b" {
  allocation_id = "${aws_eip.nat-b.id}"
  subnet_id = "${aws_subnet.nat-b.id}"
  depends_on = ["aws_internet_gateway.main"]
  tags = {
    Name = "nat-b"
    environment  = var.environment
  }
}

resource "aws_nat_gateway" "nat-c" {
  allocation_id = "${aws_eip.nat-c.id}"
  subnet_id = "${aws_subnet.nat-c.id}"
  depends_on = ["aws_internet_gateway.main"]
  tags = {
    Name = "nat-c"
    environment  = var.environment
  }
}

resource "aws_eip" "nat-a" {
  vpc = true
  tags = {
    Name = "nat-a"
    environment  = var.environment
  }
}

resource "aws_eip" "nat-b" {
  vpc = true
  tags = {
    Name = "nat-b"
    environment  = var.environment
  }
}

resource "aws_eip" "nat-c" {
  vpc = true
  tags = {
    Name = "nat-c"
    environment  = var.environment
  }
}

resource "aws_security_group" "default-sg" {
  name        = "default-sg"
  description = "Default secrity group"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [
      "0.0.0.0/0",
    ]
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
    Name = "default-sg"
    environment  = var.environment
  }
}
