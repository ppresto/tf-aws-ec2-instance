//--------------------------------------------------------------------
// Modules
module "instance_module" {
  source  = "app.terraform.io/ppresto_ptfe/instance-module/aws"
  version = "1.0.4-k-cidr"

  ingress_cidr_block = "0.0.0.0/0"
}
