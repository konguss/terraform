terraform {
  backend "s3" {
    bucket = "terraform-state-backupend"
    key = "vpc"
    region = "ap-southeast-1"
    encrypt = "true"
  }
}
