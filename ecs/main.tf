provider "aws" {
	region = "us-east-1"
}

data "terraform_remote_state" "iam_roles" {
	backend = "s3"
	config {
		bucket = "tfstate-alex"
		key = "tf/vpc/terraform.tfstate"
		region = "us-east-1"
	}
}

resource "aws_ecs_cluster" "minecraft" {
	name = "minecraft"
}

module "ecs_instance" {
	source = "../modules/server"
	ami = "ami-b2df2ca4"
	instance_type = "t2.micro"
	user_data = "${file("files/user_data")}"
	fqdn = "vanilla.dnsname.click"
}

resource "aws_ecs_task_definition" "mc-task" {
	family = "minecraft"
	container_definitions = "${file("files/def.json")}"
	volume {
		name = "data"
		host_path = "/vanilla-data/"
	}
}

resource "aws_ecs_service" "minecraft" {
  name = "mc-service"
  cluster = "${aws_ecs_cluster.minecraft.id}"
  task_definition = "${aws_ecs_task_definition.mc-task.arn}"
  desired_count = 1
}