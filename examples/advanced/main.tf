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
  version = "0.1.3"
  name_prefix = "ppresto2-dev"
  vpc_id = "${data.terraform_remote_state.patrick_tf_aws_standard_network.vpc_id}"

//--------------------------------------------------------------------
// Optional Attributes
  count = 1
  egress_cidr_block = "0.0.0.0/0"
  http_port = 80
  https_port = 443
  ingress_cidr_block = "157.131.174.226/32"
  instance_type = "t2.micro"
  public = "true"
  region = "us-west-2"
  tfe_host = "app.terraform.io"
  tfe_org = "Patrick"
  tfe_workspace = "tf-aws-standard-network"
}