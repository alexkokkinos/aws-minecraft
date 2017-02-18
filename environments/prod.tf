provider "aws" {
	region = "us-east-1"
}

module "prod" {
	source = "../modules/server"
	ami = "ami-0b33d91d"
	instance_type = "t2.micro"
}