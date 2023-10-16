terraform {
  backend "s3" {
    encrypt = true    
    bucket = "dynamic_env-gpoc-tfstate"
    dynamodb_table = "dynamic_env-gpoc-tfstate-lock-dynamo"
    key    = "terraform.tfstate"
    region = "ap-northeast-1"
  }
}