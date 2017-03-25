provider "aws" {
	region = "us-east-1"
}

resource "aws_ecs_cluster" "minecraft" {
	name = "minecraft"
}

module "server1" {
	source = "../modules/ecs-tenant"
	data_location = "efs/vanilla"
	fqdn = "minecraft.dnsname.click"
	environment_name = "prod"
	whitelist = "${var.whitelist}"
	type = "VANILLA" # VANILLA, FORGE, SPIGOT, BUKKIT, PAPER, FTB
	ops = "${var.ops}"
}
