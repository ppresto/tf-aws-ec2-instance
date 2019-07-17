//--------------------------------------------------------------------
// Variables



//--------------------------------------------------------------------
// Modules
module "instance_module" {
  source  = "app.terraform.io/ppresto_ptfe/instance-module/aws"
  version = "1.0.1"

  key_name = "${module.ssh_keypair_module.name}"
  region = "us-west-2"
}

module "ssh_keypair_module" {
  source  = "app.terraform.io/ppresto_ptfe/ssh-keypair-module/aws"
  version = "0.2.1"
}

