module "GO_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name        = "${var.env_name}-${var.project}-GO-sg"
  description = "Security group for web-server with HTTP ports open within VPC"
  vpc_id      = "vpc-015d0d851ac305f9d"

  ingress_cidr_blocks = ["0.0.0.0/0"]
}