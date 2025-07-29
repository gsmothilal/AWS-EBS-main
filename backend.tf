terraform {
  backend "s3" {
    bucket = "terraform-state-pratyushaa-ebs-why3"
    key    = "ebs/dev/terraform.tfstate"
    region = "us-east-1"
  }
}
