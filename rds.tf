resource "aws_security_group" "_" {
  name = "${local.resource_name_prefix}-rds-sg"

  description = "RDS (terraform-managed)"
  vpc_id      = var.rds_vpc_id

  # Only MySQL in
  ingress {
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = var.sg_ingress_cidr_block
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.sg_egress_cidr_block
  }
}
