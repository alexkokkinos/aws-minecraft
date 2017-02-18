resource "aws_security_group" "minecraft" {
	name = "SSH from home"
	description = "Minecraft server security group"
	vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"
}

resource "aws_security_group_rule" "egress_all" {
	from_port = 0
	to_port = 65535
	protocol = "-1"
	cidr_blocks = ["0.0.0.0/0"]
	security_group_id = "${aws_security_group.ssh_from_home.id}"
}

resource "aws_security_group_rule" "ssh_from_home" {
	from_port = 22
	to_port = 22
	protocol = "tcp"
	cidr_blocks = ["${var.home_ip}"]
	security_group_id = "${aws_security_group.ssh_from_home.id}"
}

resource "aws_security_group_rule" "egress_all" {
	from_port = 25565
	to_port = 25565
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
	security_group_id = "${aws_security_group.ssh_from_home.id}"
}