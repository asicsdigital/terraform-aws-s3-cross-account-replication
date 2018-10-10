# Destination bucket policy to add manually

output "dest_bucket_policy_json" {
  value = "${var.create_dest_bucket == "true" ? "not needed" : data.aws_iam_policy_document.dest_bucket_policy.json}"
}

# Source write IAM user

output "source_write_iam_user_access_key_id" {
  value = "${aws_iam_access_key.source_write.id}"
}

output "source_write_iam_user_secret_access_key" {
  value     = "${aws_iam_access_key.source_write.secret}"
  sensitive = true
}
