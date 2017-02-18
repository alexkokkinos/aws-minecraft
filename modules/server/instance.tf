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

resource "aws_iam_instance_profile" "minecraft" {
	name = "minecraft_profile"
	roles = ["${aws_iam_role.minecraft.name}"]
}