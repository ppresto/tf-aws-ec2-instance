# PROVIDER CONFIGURATION - AWS
provider "aws" {
  region = "${var.region}"
}

# Get Network VPC Workspace Outputs
#
#        All needed outputs could be obtained with this data source alone.  
#        We added an additional variable below "var.vpc_id" to force/show interpolation input in the UI Config Designer
#        Example UI Input: ${data.terraform_remote_state.tfeOrg_workspaceName.attribute}
#
#  BUG: The UI Configuration Designer appears to have a Bug in the generated data source output.  Add "https://" to the address.
#       address = "https://app.terraform.io"
#

data "terraform_remote_state" "vpc" {
  backend = "remote"

  config = {
    hostname     = "${var.tfe_host}"
    organization = "${var.tfe_org}"

    workspaces = {
      name = "${var.tfe_workspace}"
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
    Name  = "${var.name_prefix}-${count.index}"
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
  vpc_id      = "${var.vpc_id}"
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
