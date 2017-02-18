data "terraform_remote_state" "vpc" {
	backend = s3
	config = {
		name = "terraform_state/vpc"
	}
}