
variable "vpc_cidr" {
  default = "10.10.0.0/16"
}

variable "vpc_tag" {
  default = "custom-vpc"
}

variable "subnet_cidr" {
  default = "10.10.0.0/24"
}

variable "subnet_tag" {
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

variable "ssh_key_name" {
  default = "key-pair-jens"
}
