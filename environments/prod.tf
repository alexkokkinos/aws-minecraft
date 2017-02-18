provider "aws" {
	region = "us-east-1"
}

module "prod" {
	source = "../modules/server"
	ami = "ami-f0768de6"
	instance_type = "t2.micro"
}