output "public_ip" {
    value = "${aws_instance.main.public_ip}"
}

output "security_group_id" {
  value = "${aws_security_group.main.id}"
}
