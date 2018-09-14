# terraform-aws-s3-cross-account-replication
Terraform Module for managing s3 bucket cross-account cross-region replication.

----------------------

#### Required
- `source_bucket_name` - Name for the source bucket (which will be created by this module)
- `source_aws_profile` - AWS Profile name for the source AWS account
- `source_region`      - Region for source bucket
- `dest_bucket_name`   - Name for the destination bucket (which will also be created by this module)
- `dest_aws_profile`   - AWS Profile name for the destination AWS account
- `dest_region`        - Region for the destination bucket
- `replication_name`   - Short name for this replication (used in IAM roles and source bucket configuration)

#### Optional


Usage
-----

```hcl

module "s3-cross-account-replication" {
  source             = "github.com/asicsdigital/terraform-aws-s3-cross-account-replication:v1.0.0"
  source_bucket_name = "source-bucket"
  source_aws_profile = "source-account-aws-profile"
  source_region      = "us-west-1"
  dest_bucket_name   = "dest-bucket"
  dest_aws_profile   = "dest-account-aws-profile"
  dest_region        = "us-east-1"
  replication_name   = "my-replication-name"
}


```

Outputs
=======


Authors
=======

* [John Noss](https://github.com/jnoss)


Changelog
=========


License
=======

This software is released under the MIT License (see `LICENSE`).
