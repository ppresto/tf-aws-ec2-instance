//--------------------------------------------------------------------
// Workspace Data
data "terraform_remote_state" "patrick_tf_aws_standard_network" {
  backend = "atlas"
  config = {
    address = "https://app.terraform.io"
    name    = "Patrick/tf-aws-standard-network"
  }
}

//--------------------------------------------------------------------
// Modules
module "ec2_instance" {
  #source  = "../../"
  source  = "app.terraform.io/Patrick/ec2_instance/aws"
  version = "2.0.8"
  instance_count = 2
  name_prefix = "${var.name_prefix}"
  security_group = "${data.terraform_remote_state.patrick_tf_aws_standard_network.outputs.security_group_web}"
  tags = {
    owner = "ppresto@hashicorp.com"
    TTL   = 24
  }
}
