locals {
  "source_bucket_arn"        = "arn:aws:s3:::${var.source_bucket_name}"
  "dest_bucket_arn"          = "arn:aws:s3:::${var.dest_bucket_name}"
  "source_bucket_object_arn" = "arn:aws:s3:::${var.source_bucket_name}/${var.replicate_prefix}*"
  "dest_bucket_object_arn"   = "arn:aws:s3:::${var.dest_bucket_name}/${var.replicate_prefix}*"
  "replication_name"         = "tf-${var.replication_name}"
  "source_root_user_arn"     = "arn:aws:iam::${data.aws_caller_identity.source.account_id}:root"
}
