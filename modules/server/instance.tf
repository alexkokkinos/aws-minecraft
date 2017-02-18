resource "aws_instance" "minecraft_server" {
    ami = "${var.ami}"
    instance_type = "${var.instance_type}"
    subnet_id = "${data.terraform_remote_state.subnet_public1a_id}"
    user_data = "${file.("user_data/user_data")}"
    aws_security_groups = [
        "${aws_security_group.minecraft.id}"
    ]
}

