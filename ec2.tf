module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${var.env_name}-${var.project}-GO1"

  instance_type          = var.ec2_instance_type
  ami                    = var.ec2_ami_id
  key_name               = "user1"
  monitoring             = true
  user_data              = file("userdata.sh")
  associate_public_ip_address = true
  iam_instance_profile   = "MySessionManagerRole"
  vpc_security_group_ids = [module.GO_sg.security_group_id]
  subnet_id              = var.public_subnet_id_1

  tags = {
    Environment = var.env_name
    Project = var.project

  }
}