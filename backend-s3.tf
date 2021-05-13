terraform {
  backend "s3" {
    bucket = "terraform-vprofile-state-143"
    key    = "terraform/backend"
    region = "us-east-2"
  }
}
