terraform {
  backend "s3" {
    bucket = "terraform-state-backupend"
    key = "vpc2"
    region = "ap-southeast-1"
    encrypt = "true"
  }
}