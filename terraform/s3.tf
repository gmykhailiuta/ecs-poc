resource "aws_s3_bucket" "lb-logs-bucket" {
  bucket = var.logs_s3_bucket
  acl = "private"
  # Allow LBs to write logs to this bucket
  policy = data.aws_iam_policy_document.lb-logs-bucket.json
  force_destroy = true

  lifecycle_rule {
    id      = "root"
    enabled = true

    expiration {
      days = 7
    }
  }

  tags = {
    Name = var.logs_s3_bucket
    environment = var.environment
  }
}

data "aws_iam_policy_document" "lb-logs-bucket" {
  statement {
    effect = "Allow"
    actions = [
        "s3:PutObject"
    ]
    principals {
      type = "AWS"
      identifiers = ["arn:aws:iam::156460612806:root"]
    }
    resources = [ "arn:aws:s3:::${var.logs_s3_bucket}/*/AWSLogs/${var.account_id}/*" ]
  }
}
