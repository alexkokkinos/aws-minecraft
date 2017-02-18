resource "aws_eip" "minecraft" {
  vpc                       = true
  associate_with_private_ip = "${aws_instance.minecraft_server.private_ip}"
}