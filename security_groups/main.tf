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

resource "aws_security_group" "minecraft" {
	name = "Minecraft"
	description = "Minecraft server security group"
	vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"
}

resource "aws_security_group" "efs" {
	name = "EFS"
	description = "Elastic File Storage security group"
	vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"
}

resource "aws_security_group" "rds" {
	name = "RDS"
	description = "Allows RDS access from web system"
	vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"
}

resource "aws_security_group_rule" "ingress_rds" {
	from_port = 5432
	to_port = 5432
	protocol = "tcp"
	type = "ingress"
	source_security_group_id = "${aws_security_group.minecraft.id}"
	security_group_id = "${aws_security_group.rds.id}"
}

resource "aws_security_group_rule" "egress_all" {
	from_port = 0
	to_port = 65535
	protocol = "-1"
	type = "egress"
	cidr_blocks = ["0.0.0.0/0"]
	security_group_id = "${aws_security_group.minecraft.id}"
}

resource "aws_security_group_rule" "egress_all_2" {
	from_port = 0
	to_port = 65535
	protocol = "-1"
	type = "egress"
	cidr_blocks = ["0.0.0.0/0"]
	security_group_id = "${aws_security_group.rds.id}"
}

resource "aws_security_group_rule" "ssh_from_home" {
	from_port = 22
	to_port = 22
	protocol = "tcp"
	type = "ingress"
	cidr_blocks = ["${var.home_ip}"]
	security_group_id = "${aws_security_group.minecraft.id}"
}

resource "aws_security_group_rule" "ingress_minecraft" {
	from_port = 25565
	to_port = 25565
	protocol = "tcp"
	type = "ingress"
	cidr_blocks = ["0.0.0.0/0"]
	security_group_id = "${aws_security_group.minecraft.id}"
}

resource "aws_security_group_rule" "ingress_rcon" {
	from_port = 28016
	to_port = 28016
	protocol = "tcp"
	type = "ingress"
	cidr_blocks = ["0.0.0.0/0"]
	security_group_id = "${aws_security_group.minecraft.id}"
}

resource "aws_security_group_rule" "efs_mount_target" {
	from_port = 2049
	to_port = 2049
	protocol = "tcp"
	type = "ingress"
	security_group_id = "${aws_security_group.efs.id}"
	source_security_group_id = "${aws_security_group.minecraft.id}"
}

resource "aws_security_group_rule" "efs_allow_all" {
	from_port = 2049
	to_port = 2049
	protocol = "tcp"
	type = "ingress"
	security_group_id = "${aws_security_group.efs.id}"
	cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "efs_out" {
	from_port = 0
	to_port = 65535
	protocol = "-1"
	type = "egress"
	cidr_blocks = ["0.0.0.0/0"]
	security_group_id = "${aws_security_group.efs.id}"
}

output "sg_minecraft" {
	value = "${aws_security_group.minecraft.id}"
}

output "sg_efs_mount_target" {
	value = "${aws_security_group.efs.id}"
}

output "sg_rds" {
	value = "${aws_security_group.rds.id}"
}
