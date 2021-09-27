terraform {
  backend "s3" {
    bucket = "terraform-state-backupend"
    key = "ec2"
    region = "ap-southeast-1"
    encrypt = "true"
  }
}
data "terraform_remote_state" "vpc" {
    backend = "s3"
    config = {
      bucket = "terraform-state-backupend"
      key = "vpc"
      region = "ap-southeast-1"
    }
}