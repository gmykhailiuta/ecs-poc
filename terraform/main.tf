terraform {
  required_version = "0.12.6"
}

provider "aws" {
  version = "2.26.0"
  allowed_account_ids = ["${var.account_id}"]
  region = var.region
}

provider "template" {
  version = "2.1.2"
}

resource "aws_key_pair" "deployer-key" {
  key_name   = "deployer-key"
  public_key = "${var.deployer_ssh_key}"
}
