variable "vpc_id" {}
variable "subnet_id" {}

variable "workstation_private_key" {
  description = "The ssh private key material in pem format that will be installed into the instance"
  type = string
}

variable "instance_type" {
  description = "The type of instance that will host the workstation"
  default = "t3a.nano"
  type = string
}

variable "fqdn" {
  description = "Should be in the format of example.com"
  type = string
}
variable "subdomain" {
  description = "Should be a alphanumeric string conforming to url naming restrictions"
  type = string
}

variable "ssh_key_name" {
  description = "The name of the ssh keys that will be used to connect to this instance"
  type = string
}

variable "archlinux_lts_ami_id" {
  default = "ami-01d988fc8ed4684e6"
  description = "Archlinux official image from uplinklabs"
}
