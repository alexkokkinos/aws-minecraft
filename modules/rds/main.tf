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
  engine_version       = "9.6"
  instance_class       = "db.t2.micro"
  name                 = "chunk"
  username             = "superuser"
  password             = "${var.db_password}"
  db_subnet_group_name = "${aws_db_subnet_group.rds.id}"
  vpc_security_group_ids = ["${data.terraform_remote_state.security_groups.sg_minecraft}"]
  multi_az = true
}

resource "aws_db_subnet_group" "rds" {
	name = "main"
	subnet_ids = [
	"${data.terraform_remote_state.vpc.subnet_private1_id}",
	"${data.terraform_remote_state.vpc.subnet_private2_id}",
	]

	tags {
		Name = "chunk subnet group"
	}
}
