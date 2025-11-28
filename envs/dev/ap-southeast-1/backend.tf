terraform {
  backend "s3" {
    bucket         = "eks-tf-state-amith-dev"
    key            = "dev/ap-southeast-1/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "eks-tf-locks"
    encrypt        = true
  }
}