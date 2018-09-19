data "aws_iam_policy_document" "source_write" {
  statement {
    actions = [
      "s3:PutObject",
    ]

    resources = [
      "${local.source_bucket_object_arn}",
    ]
  }

  statement {
    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "${local.source_bucket_arn}",
    ]
  }
}

resource "aws_iam_policy" "source_write" {
  provider    = "aws.source"
  name_prefix = "${local.replication_name}-source-write-"
  policy      = "${data.aws_iam_policy_document.source_write.json}"
}

resource "aws_iam_user" "source_write" {
  provider      = "aws.source"
  name          = "${local.replication_name}-source-write-user"
  force_destroy = true
}

resource "aws_iam_user_policy_attachment" "source_write" {
  provider   = "aws.source"
  user       = "${aws_iam_user.source_write.name}"
  policy_arn = "${aws_iam_policy.source_write.arn}"
}

resource "aws_iam_access_key" "source_write" {
  provider = "aws.source"
  user     = "${aws_iam_user.source_write.name}"
}
