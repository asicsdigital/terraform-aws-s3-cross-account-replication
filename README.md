# terraform-aws-s3-cross-account-replication
Terraform Module for managing s3 bucket cross-account cross-region replication.

----------------------

#### Required

- `source_bucket_name` - Name for the source bucket (which will be created by this module)
- `source_region`      - Region for source bucket
- `dest_bucket_name`   - Name for the destination bucket (optionally created by this module)
- `dest_region`        - Region for the destination bucket
- `replication_name`   - Short name for this replication (used in IAM roles and source bucket configuration)

- Terraform 0.11 module provider inheritance block:

- `aws.source` - AWS provider alias for source account
- `aws.dest`   - AWS provider alias for destination account

#### Optional

- `create_dest_bucket` - Boolean for whether this module should create the destination bucket
- `replicate_prefix`   - Prefix to replicate, default `""` for all objects. Note if specifying, must end in a `/`

Usage
-----

```hcl

provider "aws" {
  alias   = "source"
  profile = "source-account-aws-profile"
  region  = "us-west-1"
}

provider "aws" {
  alias   = "dest"
  profile = "dest-account-aws-profile"
  region  = "us-east-1"
}

module "s3-cross-account-replication" {
  source             = "github.com/asicsdigital/terraform-aws-s3-cross-account-replication?ref=v1.0.0"
  source_bucket_name = "source-bucket"
  source_region      = "us-west-1"
  dest_bucket_name   = "dest-bucket"
  dest_region        = "us-east-1"
  replication_name   = "my-replication-name"

  providers {
    "aws.source" = "aws.source"
    "aws.dest"   = "aws.dest"
  }
}

output "dest_account_id" {
  value = "${module.s3-cross-account-replication.dest_account_id}"
}


```

#### If not creating the destination bucket with this module:

- Set `create_dest_bucket` to false
- Run terraform apply
- Copy the output `dest_bucket_policy_json` into the bucket policy for the destination bucket
- Ensure that versioning is enabled for the destination bucket (Cross-region replication requires versioning be enabled: see Requirements at https://docs.aws.amazon.com/AmazonS3/latest/dev/crr.html)
- Also follow the manual step above to enable setting owner on replicated objects

Outputs
=======

- `dest_bucket_policy_json` - The S3 bucket policy that must be added on the destination bucket manually if `create_dest_bucket` is false.

Authors
=======

* [John Noss](https://github.com/jnoss)


Changelog
=========

1.0.0 - Initial release.

License
=======

This software is released under the MIT License (see `LICENSE`).
