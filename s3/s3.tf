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
		id = "rule"
		enabled = true
		prefix = "/"
		expiration {
			days = 90
		}
	}
	tags {
		Name = "Terraform State"
	}
}