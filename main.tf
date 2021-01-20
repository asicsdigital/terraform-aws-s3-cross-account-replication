# MAIN

provider "aws" {
  alias = "source_of_replication"
}

provider "aws" {
  alias = "destination_of_replication"
}

data "aws_caller_identity" "source" {
  provider = aws.source_of_replication
}

data "aws_caller_identity" "dest" {
  provider = aws.destination_of_replication
}

