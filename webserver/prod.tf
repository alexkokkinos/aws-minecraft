provider "aws" {
	region = "us-east-1"
}

module "webserver" {
	source = "../modules/server"
	ami = "ami-c58c1dd3"
	instance_type = "t2.micro"
	fqdn = "${var.fqdn}"
}
