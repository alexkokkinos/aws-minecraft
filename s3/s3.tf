data "terraform_remote_state" "vpc" {
	backend = s3
	config = {
		name = "terraform_state.alexkokkinos/vpc"
	}
}

resource "aws_s3_bucket" "terraform_state" {
	bucket = "terraform_state.alexkokkinos"
	acl = "private"
	tags {
		Name = "Terraform State"
	}
}