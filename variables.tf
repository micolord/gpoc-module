variable "region" {
    description = "AWS deployment region"
}

variable "project" {
    description = "Project name"
}

variable "env_name" {
    description = "Environment Name"
}

variable "vpc_cidr" {
    description = "VPC CIDR block"
}

variable "vpc_id" {
    description = "VPC ID"
}

#variable "public_subnet_cidr_1" {
#    description = "Public subnet CIDR block"
#}

#variable "public_subnet_cidr_2" {
#    description = "Public subnet CIDR block"
#}

variable "public_subnet_id_1" {
    description = "Public subnet CIDR block"
}

variable "public_subnet_id_2" {
    description = "Public subnet CIDR block"
}

#variable "public_subnet_cidr_3" {
#    description = "Public subnet CIDR block"
#}

#variable "private_subnet_cidr_1" {
#    description = "Private subnet CIDR block"
#}

#variable "private_subnet_cidr_2" {
#    description = "Private subnet CIDR block"
#}

variable "private_subnet_id_1" {
    description = "Private subnet CIDR block"
}

variable "private_subnet_id_2" {
    description = "Private subnet CIDR block"
}

#variable "private_subnet_cidr_3" {
#    description = "Private subnet CIDR block"
#}

variable "availability_zone_1" {
    description = "Availability Zone A"
}

variable "availability_zone_2" {
    description = "Availability Zone B"
}

variable "ec2_ami_id" {
    description = "Instance AMI"
}

variable "ec2_instance_type" {
    description = "Instance type"
}

#variable "master_instance_class" {
 #   description = "Instance type"
#}