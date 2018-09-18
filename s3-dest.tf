# S3 destination bucket

data "aws_iam_policy_document" "dest_bucket_policy" {
  statement {
    sid = "1"

    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ObjectOwnerOverrideToBucketOwner",
    ]

    resources = [
      "${local.dest_bucket_object_arn}",
    ]

    principals {
      type = "AWS"

      identifiers = [
        "${local.source_root_user_arn}",
      ]
    }
  }

  statement {
    sid = "2"

    actions = [
      "s3:GetBucketVersioning",
      "s3:PutBucketVersioning",
    ]

    resources = [
      "${local.dest_bucket_arn}",
    ]

    principals {
      type = "AWS"

      identifiers = [
        "${local.source_root_user_arn}",
      ]
    }
  }
}

resource "aws_s3_bucket" "dest" {
  provider = "aws.dest"
  bucket   = "${var.dest_bucket_name}"
  region   = "${var.dest_region}"
  policy   = "${data.aws_iam_policy_document.dest_bucket_policy.json}"

  versioning {
    enabled = true
  }
}
