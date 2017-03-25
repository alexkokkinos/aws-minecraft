provider "aws" {
	region = "us-east-1"
}

resource "aws_ecs_cluster" "minecraft" {
	name = "minecraft"
}

module "ecs_instance" {
	source = "../modules/server"
	ami = "ami-b2df2ca4"
	instance_type = "t2.micro"
	user_data = "${file("../modules/ecs-tenant/files/user_data")}"
	fqdn = "${var.fqdn}"
}

module "server1" {
	source = "../modules/ecs-tenant"
	data_location = "efs/vanilla"
	environment_name = "prod"
	whitelist = "${var.whitelist}"
	type = "VANILLA" # VANILLA, FORGE, SPIGOT, BUKKIT, PAPER, FTB
	ops = "${var.ops}"
}
