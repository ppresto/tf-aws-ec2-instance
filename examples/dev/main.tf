# PROVIDER CONFIGURATION - AWS
provider "aws" {
  region = "${var.region}"
}

# Get VPC
data "terraform_remote_state" "vpc" {
  backend = "remote"

  config = {
    hostname     = "app.terraform.io"
    organization = "Patrick"

    workspaces = {
      name = "tf-aws-standard-network"
    }
  }
}

# RESOURCE CONFIGURATION - AWS
resource "aws_instance" "main" {
  count                       = "${var.count}"
  ami                         = "${data.aws_ami.ubuntu.id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${data.terraform_remote_state.vpc.ssh_key_name}"
  associate_public_ip_address = "${var.public}"
  vpc_security_group_ids      = ["${aws_security_group.app.id}"]
  subnet_id                   = "${data.terraform_remote_state.vpc.subnet_public_ids[0]}"
  depends_on                  = ["data.terraform_remote_state.vpc"]

  root_block_device {
    volume_size = "60"
  }

  tags {
    Name  = "${var.name_prefix} instance"
    owner = "ppresto@hashicorp.com"
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

resource "aws_security_group" "app" {
  name_prefix = "${var.name_prefix}-sg"
  description = "${var.name_prefix} security group"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"
  tags        = "${merge(var.tags, map("Name", format("%s-mynode", var.name_prefix)))}"
}

resource "aws_security_group_rule" "ssh" {
  security_group_id = "${aws_security_group.app.id}"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["${var.ingress_cidr_block}"]
}

resource "aws_security_group_rule" "http" {
  security_group_id = "${aws_security_group.app.id}"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = "${var.http_port}"
  to_port           = "${var.http_port}"
  cidr_blocks       = ["${var.ingress_cidr_block}"]
}

resource "aws_security_group_rule" "https" {
  security_group_id = "${aws_security_group.app.id}"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = "${var.https_port}"
  to_port           = "${var.https_port}"
  cidr_blocks       = ["${var.ingress_cidr_block}"]
}

resource "aws_security_group_rule" "egress" {
  security_group_id = "${aws_security_group.app.id}"
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["${var.ingress_cidr_block}"]
}