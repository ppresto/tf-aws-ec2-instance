# Create a new instance of Ubuntu on an
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
  owners = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "main" {
  count                       = "${var.instance_count != "" ? var.instance_count : 0}"
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = data.terraform_remote_state.vpc.outputs.ssh_key_name
  associate_public_ip_address = var.public
  vpc_security_group_ids      = [var.security_group]
  subnet_id                   = "${var.subnetid != "" ? var.subnetid : data.terraform_remote_state.vpc.outputs.subnet_public_ids[0]}"
  depends_on                  = ["data.terraform_remote_state.vpc"]
  
  tags = {
    Name  = "${var.name_prefix}_${count.index+1}"
    owner = "ppresto@hashicorp.com"
    TTL   = 24
  }
}
