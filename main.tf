# PROVIDER CONFIGURATION - AWS
provider "aws" {
  region = "${var.region}"
}

# RESOURCE CONFIGURATION - AWS
resource "aws_instance" "main" {
  ami                         = "${data.aws_ami.ubuntu.id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${module.ssh_keypair_module.name}"
  associate_public_ip_address = "${var.public}"
  vpc_security_group_ids      = ["${aws_security_group.main.id}"]
  depends_on                  = ["aws_security_group.main"]

  root_block_device {
    volume_size = "60"
  }

  tags {
    Name  = "${var.name_prefix} instance"
    owner = "youremail@email.com"
    TTL   = 24
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags {
    Name = "${var.name_prefix}-vpc"
  }
}

resource "aws_security_group" "main" {
  name        = "${var.name_prefix}-sg"
  description = "${var.name_prefix} security group"

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["${var.ingress_cidr_block}"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["${var.ingress_cidr_block}"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["${var.ingress_cidr_block}"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 8800
    to_port     = 8800
    cidr_blocks = ["${var.ingress_cidr_block}"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["${var.egress_cidr_block}"]
  }
}

module "ssh_keypair_module" {
  source  = "app.terraform.io/ppresto_ptfe/ssh-keypair-module/aws"
  version = "0.2.1"
}
