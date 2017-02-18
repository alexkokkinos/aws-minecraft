provider "aws" {
	region = "us-east-1"
}

resource "aws_vpc" "vpc" {
	cidr_block = "10.0.0.0/16"
	tags {
	  Name = "minecraft"
	}
}

resource "aws_subnet" "public1a" {
	vpc_id =  "${aws_vpc.vpc.id}"
	cidr_block = "10.0.0.0/24"
	map_public_ip_on_launch = "true"

	tags {
		Name = "Public 1A"
	}
}

resource "aws_internet_gateway" "gateway" {
	vpc_id = "${aws_vpc.vpc.id}"

	tags {
		Name = "Minecraft"
	}
}

output "vpc_id" {
	value = "${aws_vpc.vpc.id}"
}

output "subnet_public1a_id" {
	value = "${aws_subnet.public1a.id}"
}

resource "aws_route_table" "internet_route" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gateway.id}"
  }
}

resource "aws_route_table_association" "one" {
  subnet_id = "${aws_subnet.public1a.id}"
  route_table_id = "${aws_route_table.internet_route.id}"
}