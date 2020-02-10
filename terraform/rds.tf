resource "aws_security_group" "rds" {
  name = "rds"
  description = "Access to RDS instances"
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    security_groups = [
      "${aws_security_group.app-sg.id}"
    ]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "rds"
    env = var.environment
  }
}

resource "aws_db_subnet_group" "default" {
  name = "default-db-subnet-group"
  description = "default db subnet group"
  subnet_ids = [
    "${aws_subnet.data-a.id}",
    "${aws_subnet.data-b.id}",
    "${aws_subnet.data-c.id}"
  ]
  tags = {
    Name = "default"
    env = var.environment
  }
}

resource "aws_db_instance" "db01" {
  identifier = "db01"
  engine = "postgres"
  engine_version = "11.5"
  multi_az = "false"
  instance_class = "db.t3.micro"
  storage_type = "gp2"
  allocated_storage = 10
  storage_encrypted = "false"
  vpc_security_group_ids = ["${aws_security_group.rds.id}"]
  publicly_accessible = "false"
  db_subnet_group_name = "${aws_db_subnet_group.default.id}"
  maintenance_window = "Sun:02:00-Sun:04:00"
  backup_retention_period = 0
  auto_minor_version_upgrade = false
  allow_major_version_upgrade = false
  skip_final_snapshot = true
  username = "postgres"
  # Change this upon RDS creation!
  password = "pKw6mUpR7N6jbNsZ3AQVNnCe"
  port = "5432"
  apply_immediately = "true"
  tags = {
    Name = "db01"
    environment = var.environment
  }
}
