# S3 source IAM and bucket

# S3 source IAM

data "aws_iam_policy_document" "source_replication_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "source_replication_policy" {
  statement {
    actions = [
      "s3:GetReplicationConfiguration",
      "s3:ListBucket",
    ]

    # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
    # force an interpolation expression to be interpreted as a list by wrapping it
    # in an extra set of list brackets. That form was supported for compatibility in
    # v0.11, but is no longer supported in Terraform v0.12.
    #
    # If the expression in the following list itself returns a list, remove the
    # brackets to avoid interpretation as a list of lists. If the expression
    # returns a single list item then leave it as-is and remove this TODO comment.
    resources = [
      local.source_bucket_arn,
    ]
  }

  statement {
    actions = [
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionAcl",
    ]

    # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
    # force an interpolation expression to be interpreted as a list by wrapping it
    # in an extra set of list brackets. That form was supported for compatibility in
    # v0.11, but is no longer supported in Terraform v0.12.
    #
    # If the expression in the following list itself returns a list, remove the
    # brackets to avoid interpretation as a list of lists. If the expression
    # returns a single list item then leave it as-is and remove this TODO comment.
    resources = [
      local.source_bucket_object_arn,
    ]
  }

  statement {
    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ObjectOwnerOverrideToBucketOwner",
    ]

    # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
    # force an interpolation expression to be interpreted as a list by wrapping it
    # in an extra set of list brackets. That form was supported for compatibility in
    # v0.11, but is no longer supported in Terraform v0.12.
    #
    # If the expression in the following list itself returns a list, remove the
    # brackets to avoid interpretation as a list of lists. If the expression
    # returns a single list item then leave it as-is and remove this TODO comment.
    resources = [
      local.dest_bucket_object_arn,
    ]
  }
}

resource "aws_iam_role" "source_replication" {
  provider           = aws.source_of_replication
  name               = "${local.replication_name}-replication-role"
  assume_role_policy = data.aws_iam_policy_document.source_replication_role.json
}

resource "aws_iam_policy" "source_replication" {
  provider = aws.source_of_replication
  name     = "${local.replication_name}-replication-policy"
  policy   = data.aws_iam_policy_document.source_replication_policy.json
}

resource "aws_iam_role_policy_attachment" "source_replication" {
  provider   = aws.source_of_replication
  role       = aws_iam_role.source_replication.name
  policy_arn = aws_iam_policy.source_replication.arn
}

# S3 source bucket

resource "aws_s3_bucket" "source" {
  provider = aws.source_of_replication
  bucket   = var.source_bucket_name
  region   = var.source_region

  versioning {
    enabled = true
  }

  replication_configuration {
    role = aws_iam_role.source_replication.arn

    rules {
      id     = local.replication_name
      status = "Enabled"
      priority = var.priority
      prefix = var.replicate_prefix

      destination {
        bucket        = local.dest_bucket_arn
        storage_class = "STANDARD"

        access_control_translation {
          owner = "Destination"
        }

        account_id = data.aws_caller_identity.dest.account_id
      }
    }
  }
}
