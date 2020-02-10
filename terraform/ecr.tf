resource "aws_ecr_repository" "app" {
  name                 = "app"
  image_tag_mutability = "MUTABLE"
  tags = {
    Name = "app"
    environment = var.environment
  }
}
