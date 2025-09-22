#touch main.tf variable.tf output.tf provider.tf backend.tf

terraform {
  backend "s3" {
    bucket  = "dev-taya-aehsc-tf-state"
    key     = "dev-taya-tf/state.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}