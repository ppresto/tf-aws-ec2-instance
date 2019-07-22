output "public_ip" {
  value = "${aws_instance.main.*.public_ip}"
}

output "private_key_pem" {
  value = "${module.ssh_keypair_module.private_key_pem}"
}

output "public_key_pem" {
  value = "${module.ssh_keypair_module.public_key_pem}"
}

output "aws_keypair_name" {
  value = "${module.ssh_keypair_module.name}"
}
