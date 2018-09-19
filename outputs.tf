# Destination Account ID

output "dest_account_id" {
  value = "${data.aws_caller_identity.dest.account_id}"
}

# Source write IAM user

output "source_write_iam_user_access_key_id" {
  value = "${aws_iam_access_key.source_write.id}"
}

# to decrypt:
# echo -n "<THE ENCRYPTED SECRET>" | base64 --decode | keybase pgp decrypt
output "source_write_iam_user_encrypted_secret_access_key" {
  value = "${aws_iam_access_key.source_write.encrypted_secret}"
}
