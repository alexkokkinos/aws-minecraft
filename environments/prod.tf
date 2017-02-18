module "prod" {
	source = "../modules/server"
	ami = ""
	instance_type = "t2.micro"
	
}