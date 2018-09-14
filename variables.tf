variable "source_aws_profile" {
  type        = "string"
  description = "AWS profile to use when managing resources in the source account"
}

variable "dest_aws_profile" {
  type        = "string"
  description = "AWS profile to use when managing resources in the destination account"
}

variable "source_region" {
  type        = "string"
  description = "AWS region for the source bucket"
}

variable "dest_region" {
  type        = "string"
  description = "AWS region for the destination bucket"
}

variable "source_bucket_name" {
  type        = "string"
  description = "Name for source s3 bucket"
}

variable "dest_bucket_name" {
  type        = "string"
  description = "Name for dest s3 bucket"
}

variable "replication_name" {
  type        = "string"
  description = "Short name to describe this replication"
}
