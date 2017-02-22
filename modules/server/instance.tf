variable "ami" {
  type = "string"
}

variable "instance_type" {
  type = "string"
}

resource "aws_instance" "minecraft_server" {
    ami = "${var.ami}"
    instance_type = "${var.instance_type}"
    subnet_id = "${data.terraform_remote_state.vpc.subnet_public1a_id}"
    vpc_security_group_ids = [
        "${data.terraform_remote_state.security_groups.sg_minecraft}"
    ]
    iam_instance_profile = "${aws_iam_instance_profile.minecraft.name}"
    key_name = "mc-key"
}

resource "aws_iam_role" "minecraft" {
	name = "minecraft_role"
	assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "ecs" {
  name = "minecraft_ecs_access"
  path = "/"
  decsription = "Minecraft ECS service access"
  policy = <<EOF
{
  "Version": "2012-10-17",
  Statement: [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:registerContainerInstance"
        "ecs:DeregisterContainerInstance",
        "ecs:DiscoverPollEndpoint",
        "ecs:Submit*",
        "ecs:Poll",
        "ecs:StartTask",
        "ecs:StartTelemetrySession"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "ecs" {
  name = "ecs_attachment"
  role = ["${aws_iam_role.minecraft.id}"]
  policy_arn = "aws_iam_policy.ecs.arn"
}

resource "aws_iam_instance_profile" "minecraft" {
	name = "minecraft_profile"
	roles = ["${aws_iam_role.minecraft.name}"]
}

output "instance_id" {
  value = "aws_instance.minecraft_server.id"
}

output "iam_role_arn" {
  value = "aws_iam_role.minecraft.arn"
}