# S3 source IAM and bucket

# S3 source IAM

data "aws_iam_policy_document" "replication_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "replication_policy" {
  statement {
    actions = [
      "s3:GetReplicationConfiguration",
      "s3:ListBucket",
    ]

    resources = [
      "${local.source_bucket_arn}",
    ]
  }

  statement {
    actions = [
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionAcl",
    ]

    resources = [
      "${local.source_bucket_object_arn}",
    ]
  }

  statement {
    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
    ]

    resources = [
      "${local.dest_bucket_object_arn}",
    ]
  }
}

resource "aws_iam_role" "replication" {
  provider           = "aws.source"
  name               = "${local.replication_name}-role"
  assume_role_policy = "${data.aws_iam_policy_document.replication_role.json}"
}

resource "aws_iam_policy" "replication" {
  provider = "aws.source"
  name     = "${local.replication_name}-policy"
  policy   = "${data.aws_iam_policy_document.replication_policy.json}"
}

resource "aws_iam_role_policy_attachment" "replication" {
  provider   = "aws.source"
  role       = "${aws_iam_role.replication.name}"
  policy_arn = "${aws_iam_policy.replication.arn}"
}

# S3 source bucket

resource "aws_s3_bucket" "source" {
  provider = "aws.source"
  bucket   = "${var.source_bucket_name}"
  region   = "${var.source_region}"

  versioning {
    enabled = true
  }

  replication_configuration {
    role = "${aws_iam_role.replication.arn}"

    rules {
      id     = "${local.replication_name}"
      status = "Enabled"
      prefix = ""

      destination {
        bucket        = "${local.dest_bucket_arn}"
        storage_class = "STANDARD"
      }
    }
  }
}
