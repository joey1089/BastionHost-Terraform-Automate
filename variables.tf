
variable "vpc_cidr" {
  default = "10.10.0.0/16"
}

variable "vpc_custom" {
  default = "custom-vpc"
}

variable "subnet_cidr_bhec2" {
  default = "10.10.1.0/24"
}

variable "subnet_cidr_pec2" {
  default = "10.10.2.0/24"
}

variable "subnet_custom" {
  default = "custom-subnet"
}

variable "internet_gateway_tag" {
  default = "custom-igw"
}

variable "ami" {
  default = "ami-0715c1897453cabd1"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "common_ssh_key" {
  default = "common_ssh_key"
}

variable "security_group_name" {
  default = "security-group-SG"
}
