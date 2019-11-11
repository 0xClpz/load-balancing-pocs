terraform {
  backend "s3" {
    bucket = "load-balancing-poc"
    key    = "terraform/"
    region = "eu-west-1"
  }
}