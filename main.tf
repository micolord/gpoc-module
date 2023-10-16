module "ec2_instance2" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${var.env_name}-${var.project}-GO1"

  instance_type          = var.ec2_instance_type
  ami                    = var.ec2_ami_id
  key_name               = "user1"
  monitoring             = true
  user_data              = file("userdata.sh")
  associate_public_ip_address = true
  iam_instance_profile   = "MySessionManagerRole"
  vpc_security_group_ids = [module.GO_sg2.security_group_id]
  subnet_id              = var.public_subnet_id_1

  tags = {
    Environment = var.env_name
    Project = var.project

  }
}

module "GO_sg2" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name        = "${var.env_name}-${var.project}-GO-sg"
  description = "Security group for web-server with HTTP ports open within VPC"
  vpc_id      = "vpc-015d0d851ac305f9d"

  ingress_cidr_blocks = ["0.0.0.0/0"]
}