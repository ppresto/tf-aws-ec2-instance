//--------------------------------------------------------------------
// Workspace Data
data "terraform_remote_state" "patrick_tf_aws_standard_network" {
  backend = "atlas"
  config {
    address = "https://app.terraform.io"
    name    = "Patrick/tf-aws-standard-network"
  }
}

//--------------------------------------------------------------------
// Modules
module "ec2_instance" {
  source  = "app.terraform.io/Patrick/ec2_instance/aws"
  version = "0.1.5"
  name_prefix = "ppresto2-dev"
  subnet_id = "${data.terraform_remote_state.patrick_tf_aws_standard_network.subnet_public_ids[0]}"
}