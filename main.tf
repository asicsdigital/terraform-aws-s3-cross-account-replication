# MAIN

provider "aws" {
  alias   = "source"
  profile = "${var.source_aws_profile}"
  region  = "${var.source_region}"
}

provider "aws" {
  alias   = "dest"
  profile = "${var.dest_aws_profile}"
  region  = "${var.dest_region}"
}

data "aws_caller_identity" "source" {
  provider  = "aws.source"
}
