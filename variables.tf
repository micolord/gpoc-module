variable "ec2_instance_type" {
  description = "The EC2 instance type"
  type        = string
}

variable "ec2_ami_id" {
  description = "The ID of the Amazon Machine Image (AMI)"
  type        = string
}

variable "env_name" {
  description = "Environment name"
  type        = string
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "public_subnet_id_1" {
  description = "ID of the public subnet"
  type        = string
}
