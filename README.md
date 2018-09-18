# terraform-aws-s3-cross-account-replication
Terraform Module for managing s3 bucket cross-account cross-region replication.

Note due to a feature currently missing in the Terraform AWS provider there is a manual step required after running Terraform, see below (issue on Terraform AWS provider: https://github.com/terraform-providers/terraform-provider-aws/issues/3575).

----------------------

#### Required

- `source_bucket_name` - Name for the source bucket (which will be created by this module)
- `source_region`      - Region for source bucket
- `dest_bucket_name`   - Name for the destination bucket (which will also be created by this module)
- `dest_region`        - Region for the destination bucket
- `replication_name`   - Short name for this replication (used in IAM roles and source bucket configuration)

- Terraform 0.11 module provider inheritance block:

- `aws.source` - AWS provider alias for source account
- `aws.dest`   - AWS provider alias for destination account

#### Optional


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
  source             = "github.com/asicsdigital/terraform-aws-s3-cross-account-replication:v1.0.0"
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

#### Manual step to enable setting owner on replicated objects

Currently there is a feature missing from the Terraform AWS provider that would enable Terraform to configure replication to properly set the owner on replicated objects so that the destination account can access the objects. See https://github.com/terraform-providers/terraform-provider-aws/issues/3575

As a workaround, after running a `terraform apply`, go to the S3 console for the source account and follow these steps:

1. Navigate to the source S3 bucket
1. Click on `Management`
1. Click on `Replication`
1. Select the `Entire bucket` row in the bottom section
1. Click `Edit`
1. Click `Next`
1. Check the checkbox for `Change object ownership to destination bucket owner`
1. Enter the `dest_account_id` (provided by the output from the module when running the `terraform apply`) in the box labeled `Type account ID of destination bucket`
1. Click `Next`
1. Click `Next`
1. Click `Save`
1. Note, there will be a message about changing settings on the destination bucket - that has already been done by Terraform, so no further action is needed


Outputs
=======

- `dest_account_id` - The account ID for the destination account. Needed when performing the final required manual step in S3 Console to enable setting owner on replicated objects.

Authors
=======

* [John Noss](https://github.com/jnoss)


Changelog
=========


License
=======

This software is released under the MIT License (see `LICENSE`).
