variable "account_id" {}
variable "region" {}
variable "deployer_ssh_key" {}
variable "logs_s3_bucket" { default = "hello-app-lb-logs" }
variable "environment" { default = "dev" }
