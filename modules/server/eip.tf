resource "aws_eip" "minecraft" {
  vpc = true
  instance = "${aws_instance.minecraft_server.id}"
}

data "aws_route53_zone" "dnsname" {
	zone_id = "${var.zone_id}"
}

resource "aws_route53_record" "minecraft" {
	zone_id = "${data.aws_route53_zone.dnsname.zone_id}"
	name = "${var.fqdn}"
	type = "A"
	ttl = "300"
	records = ["${aws_eip.minecraft.public_ip}"]
}