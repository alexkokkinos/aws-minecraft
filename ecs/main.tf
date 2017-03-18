provider "aws" {
	region = "us-east-1"
}

resource "aws_ecs_cluster" "minecraft" {
	name = "minecraft"
}

module "mcservercluster1" {
	source = "../modules/ecs-tenant"
	fqdn = "vanilla.dnsname.click"
	environment_name = "prod"
	whitelist = "${var.whitelist}"
	type = "VANILLA" # VANILLA, FORGE, SPIGOT, BUKKIT, PAPER, FTB
	ops = "${var.ops}"
}