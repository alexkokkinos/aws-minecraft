provider "aws" {
	region = "us-east-1"
}

module "chunkdb1" {
	source = "../modules/rds"
}
