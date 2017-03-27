provider "aws" {
	region = "us-east-1"
}

resource "aws_ecs_cluster" "minecraft" {
	name = "minecraft"
}

module "ecs_instance" {
	source = "../modules/server"
	ami = "ami-b2df2ca4"
	instance_type = "t2.small"
	user_data = "${file("./files/user_data")}"
	fqdn = "${var.fqdn}"
}

module "server1" {
	source = "../modules/ecs-tenant"
	data_location = "efs/sever1"
	environment_name = "server-1"
	whitelist = "${var.whitelist}"
	type = "VANILLA" # VANILLA, FORGE, SPIGOT, BUKKIT, PAPER, FTB
	ops = "${var.ops}"
	desired_count = 1
}

module "server2" {
	source = "../modules/ecs-tenant"
	data_location = "efs/server2"
	environment_name = "server-2"
	whitelist = "${var.whitelist}"
	type = "VANILLA" # VANILLA, FORGE, SPIGOT, BUKKIT, PAPER, FTB
	ops = "${var.ops}"
	desired_count = 1
}
