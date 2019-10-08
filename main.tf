# Create a new instance of the latest Ubuntu 14.04 on an
# t2.micro node with an AWS Tag naming it "HelloWorld"
provider "aws" {
  region = "${var.region}"
}

data "terraform_remote_state" "vpc" {
  backend = "remote"

  config = {
    hostname = var.tfe_host
    organization = var.tfe_org

    workspaces = {
      name = var.tfe_workspace
    }
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "main" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = data.terraform_remote_state.vpc.outputs.ssh_key_name
  associate_public_ip_address = var.public
  #vpc_security_group_ids      = [var.security_group]
  vpc_security_group_ids      = [data.terraform_remote_state.vpc.outputs.security_group_web]
  subnet_id                   = data.terraform_remote_state.vpc.outputs.subnet_public_ids[0]
  depends_on                  = ["data.terraform_remote_state.vpc"]
  
  tags = {
    Name  = "${var.name_prefix}"
    owner = "ppresto@hashicorp.com"
    TTL   = 24
  }
}
