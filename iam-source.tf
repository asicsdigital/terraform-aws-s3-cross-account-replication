data "aws_iam_policy_document" "source_write" {
  statement {
    actions = [
      "s3:PutObject",
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
}

resource "aws_iam_policy" "source_write" {
  provider    = aws.source_of_replication
  name_prefix = "${local.replication_name}-source-write-"
  policy      = data.aws_iam_policy_document.source_write.json
}

resource "aws_iam_user" "source_write" {
  provider      = aws.source_of_replication
  name          = "${local.replication_name}-source-write-user"
  force_destroy = true
}

resource "aws_iam_user_policy_attachment" "source_write" {
  provider   = aws.source_of_replication
  user       = aws_iam_user.source_write.name
  policy_arn = aws_iam_policy.source_write.arn
}

resource "aws_iam_access_key" "source_write" {
  provider = aws.source_of_replication
  user     = aws_iam_user.source_write.name
}

