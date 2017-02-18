data "terraform_remote_state" "vpc" {
	backend = "s3"
	config = {
		bucket = "tfstate-alex"
		key = "tf/vpc/terraform.tfstate"
		region = "us-east-1"
	}
}

data "terraform_remote_state" "security_groups" {
	backend = "s3"
	config = {
		bucket = "tfstate-alex"
		key = "tf/security_groups/terraform.tfstate"
		region = "us-east-1"
	}
}