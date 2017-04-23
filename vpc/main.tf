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
	availability_zone = "us-east-1b"

	tags {
		Name = "Public 1A"
	}
}

resource "aws_subnet" "private1" {
	vpc_id = "${aws_vpc.vpc.id}"
	cidr_block = "10.0.1.0/24"
	availability_zone = "us-east-1b"

	tags {
		Name = "private1"
	}
}

resource "aws_subnet" "private2" {
	vpc_id = "${aws_vpc.vpc.id}"
	cidr_block = "10.0.2.0/24"
	availability_zone = "us-east-1c"

	tags {
		Name = "private2"
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

output "subnet_private1_id" {
	value = "${aws_subnet.private1.id}"
}

output "subnet_private2_id" {
	value = "${aws_subnet.private2.id}"
}

resource "aws_route_table" "internet_route" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id =  "${aws_internet_gateway.gateway.id}"
  }
}

resource "aws_route_table_association" "one" {
  subnet_id = "${aws_subnet.public1a.id}"
  route_table_id = "${aws_route_table.internet_route.id}"
}
