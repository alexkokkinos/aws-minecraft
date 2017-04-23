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

resource "aws_db_instance" "default" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "9.6.2"
  instance_class       = "db.t2.micro"
  name                 = "chunk"
  username             = "superuser"
  password             = "${var.db_password}"
  db_subnet_group_name = "${data.terraform_remote_state.vpc.subnet_public1a_id}"
  vpc_security_group_ids = ["${data.terraform_remote_state.security_groups.sg_minecraft}"]
  storage_encrypted = true
  kms_key_id = "${aws_kms_key.rds.arn}"
}

resource "aws_kms_key" "rds" {
	description = "Key for RDS"
	enable_key_rotation = true
}
