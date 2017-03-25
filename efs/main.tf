provider "aws" {
  region = "us-east-1"
}

resource "aws_efs_file_system" "worlds" {
	tags {
		Name = "minecraft-worldstore"
	}
}