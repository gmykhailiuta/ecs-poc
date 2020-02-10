resource "aws_subnet" "lb-a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.254.0.0/24"
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = "false"
  tags = {
    Name = "lb-a"
    environment = var.environment
  }
}

resource "aws_subnet" "lb-b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.254.1.0/24"
  availability_zone       = "eu-west-1b"
  map_public_ip_on_launch = "false"
  tags = {
    Name = "lb-b"
    environment = var.environment
  }
}

resource "aws_subnet" "lb-c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.254.2.0/24"
  availability_zone       = "eu-west-1c"
  map_public_ip_on_launch = "false"
  tags = {
    Name = "lb-c"
    environment = var.environment
  }
}

# PRIVATE SUBNETS
resource "aws_subnet" "data-a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.254.3.0/24"
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = "false"
  tags = {
    Name = "data-a"
    environment = var.environment
  }
}

resource "aws_subnet" "data-b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.254.4.0/24"
  availability_zone       = "eu-west-1b"
  map_public_ip_on_launch = "false"
  tags = {
    Name = "data-b"
    environment = var.environment
  }
}

resource "aws_subnet" "data-c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.254.5.0/24"
  availability_zone       = "eu-west-1c"
  map_public_ip_on_launch = "false"
  tags = {
    Name = "data-c"
    environment = var.environment
  }
}

resource "aws_subnet" "apps-a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.254.6.0/24"
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = "false"
  tags = {
    Name = "apps-a"
    environment = var.environment
  }
}

resource "aws_subnet" "apps-b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.254.7.0/24"
  availability_zone       = "eu-west-1b"
  map_public_ip_on_launch = "false"
  tags = {
    Name = "apps-b"
    environment = var.environment
  }
}

resource "aws_subnet" "apps-c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.254.8.0/24"
  availability_zone       = "eu-west-1c"
  map_public_ip_on_launch = "false"
  tags = {
    Name = "apps-c"
    environment = var.environment
  }
}

resource "aws_subnet" "nat-a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.254.9.0/24"
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = "false"
  tags = {
    Name = "nat-a"
    environment = var.environment
  }
}

resource "aws_subnet" "nat-b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.254.10.0/24"
  availability_zone       = "eu-west-1b"
  map_public_ip_on_launch = "false"
  tags = {
    Name = "nat-b"
    environment = var.environment
  }
}

resource "aws_subnet" "nat-c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.254.11.0/24"
  availability_zone       = "eu-west-1c"
  map_public_ip_on_launch = "false"
  tags = {
    Name = "nat-c"
    environment = var.environment
  }
}
