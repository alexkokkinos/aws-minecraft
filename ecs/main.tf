provider "aws" {
	region = "us-east-1"
}

module "server1" {
	source = "../modules/ecs-tenant"
	data_location = "efs/server1"
	environment_name = "server-1"
	whitelist = "${var.whitelist}"
	type = "VANILLA" # VANILLA, FORGE, SPIGOT, BUKKIT, PAPER, FTB
	ops = "${var.ops}"
	fqdn = "server1.dnsname.click"
	motd = "server1!"
}

module "server2" {
	source = "../modules/ecs-tenant"
	data_location = "efs/server2"
	environment_name = "server-2"
	whitelist = "${var.whitelist}"
	type = "VANILLA" # VANILLA, FORGE, SPIGOT, BUKKIT, PAPER, FTB
	ops = "${var.ops}"
	fqdn = "server2.dnsname.click"
	motd = "server2!"
}
