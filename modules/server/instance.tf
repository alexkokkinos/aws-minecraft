variable "ami" {
  type = "string"
}

variable "instance_type" {
  type = "string"
}

variable "user_data" {
  type = "string"
  default = ""
}

variable "tag_name" {
  type = "string"
}

resource "aws_instance" "minecraft_server" {
    ami = "${var.ami}"
    instance_type = "${var.instance_type}"
    subnet_id = "${data.terraform_remote_state.vpc.subnet_public1a_id}"
    vpc_security_group_ids = [
        "${data.terraform_remote_state.security_groups.sg_minecraft}"
    ]
    iam_instance_profile = "${data.terraform_remote_state.iam_roles.instance_profile}"
    key_name = "mc-key"
    user_data = "${var.user_data}"
    tags {
      Name = "${var.tag_name}"
    }
}

output "instance_id" {
  value = "aws_instance.minecraft_server.id"
}
