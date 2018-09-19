# MAIN

provider "aws" {
  alias = "source"
}

provider "aws" {
  alias = "dest"
}

data "aws_caller_identity" "source" {
  provider = "aws.source"
}

data "aws_caller_identity" "dest" {
  provider = "aws.dest"
}
