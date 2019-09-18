output "private_key_pem" {
  value = "${data.terraform_remote_state.vpc.ssh_key_private_pem}"
}

output "my_nodes_public_ips" {
  value = "${aws_instance.main.*.public_ip}"
}

output "my_bastion_public_ips" {
  value = "${data.terraform_remote_state.vpc.bastion_ips_public}"
}