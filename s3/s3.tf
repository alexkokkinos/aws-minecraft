provider "aws" {
	region = "us-east-1"
}

resource "aws_s3_bucket" "terraform_state" {
	bucket = "tfstate-alex"
	acl = "private"
	versioning {
		enabled = true
	}
	lifecycle_rule {
		id = "old_version_expiration"
		enabled = true
		prefix = "/"
		noncurrent_version_expiration {
			days = 90
		}
	}
	tags {
		Name = "Terraform State"
	}
}

resource "aws_s3_bucket" "saves" {
	bucket = "saves-alex"
	acl = "private"
	versioning {
		enabled = true
	}
	lifecycle_rule {
		id = "old_version_expiration"
		enabled = true
		prefix = "/"
		noncurrent_version_expiration {
			days = 365
		}
	}
	tags {
		Name = "Minecraft Saves Bucket"
	}
}