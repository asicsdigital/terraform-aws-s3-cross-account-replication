output "dest_account_id" {
  value = "${data.aws_caller_identity.dest.account_id}"
}
