resource "aws_vpc" "vpc" {
	cidr_block = "10.0.0.0/16"
	tags {
	  Name = "infra-vpc"
	}
}

resource "aws_subnet" "public1a" {
	vpc_id =  "${aws_vpc.infra.id}"
	cidr_block = "10.0.0.0/24"
	map_public_ip_on_launch = "true"
	availability_zone = "us-east-1c"

	tags {
		Name = "Public 1A"
	}
}
output "vpc_id" {
	value = "${aws_vpc.vpc.id}"
}

output "subnet_public1a_id" {
	value = "${aws_subnet.public1a.id}"
}