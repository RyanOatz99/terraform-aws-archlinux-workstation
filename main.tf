data "aws_vpc" "workstation_vpc" {
  id = var.vpc_id
}

data "aws_subnet" "workstation_subnet" {
  id = var.subnet_id
}

data "aws_route53_zone" "workstation_hosted_zone" {
  name = "${var.fqdn}."
  private_zone = false
}

resource "aws_route53_record" "workstation_record" {
  zone_id = data.aws_route53_zone.workstation_hosted_zone.zone_id
  name = "${var.subdomain}.${var.fqdn}"
  type = "A"
  ttl = 300
  records = [aws_instance.workstation.public_ip]
}

data "aws_ami" "archlinux" {
  most_recent = true

  // "arch-linux-lts-hvm-2020.01.10.x86_64-ebs"

  filter {
    name   = "image-id"
    values = [var.archlinux_lts_ami_id,]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["093273469852"] # Uplinklabs
}

resource "aws_security_group" "workstation_sg" {
  name        = "workstation_sg"
  description = "workstation_sg"
  vpc_id      = data.aws_vpc.workstation_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/templates/user_data.tpl")
  vars = {
    workstation_private_key = var.workstation_private_key
  }
}

resource "aws_instance" "workstation" {
  ami           = data.aws_ami.archlinux.id
  instance_type = var.instance_type

  tags = {
    Name = "workstation-archlinux"
  }

  key_name        = var.ssh_key_name
  security_groups = [aws_security_group.workstation_sg.id]
  subnet_id       = data.aws_subnet.workstation_subnet.id
  user_data = data.template_file.user_data.rendered
}
