provider "aws" {
  region = "us-east-1"
}

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

resource "aws_efs_file_system" "worlds" {
	tags {
		Name = "minecraft-worldstore"
	}
}

resource "aws_efs_mount_target" "target" {
  file_system_id = "${aws_efs_file_system.worlds.id}"
  subnet_id      = "${data.terraform_remote_state.vpc.subnet_public1a_id}"
  security_groups = ["${data.terraform_remote_state.security_groups.sg_efs_mount_target}"]
}
