resource "aws_security_group" "dbinstance" {
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


provider "aws" {
  region = "your-region"
}

resource "aws_db_subnet_group" "database_subnet_group" {
  name       = "database-subnet-group"
  subnet_ids = ["subnet-xxxxxx", "subnet-yyyyyy"]  # Specify the IDs of your private subnets
}

resource "aws_db_instance" "database" {
  identifier             = "your-database-identifier"
  engine                 = "mysql"  # Change the engine if you are using a different database engine
  instance_class         = "db.t2.micro"  # Adjust based on your requirements
  username               = "db-username"
  password               = "db-password"
  allocated_storage      = 20  # Adjust based on your requirements
  storage_type           = "gp2"
  multi_az               = false  # Change to true if you want a Multi-AZ deployment
  publicly_accessible    = false  # Set to false for a private RDS instance

  vpc_security_group_ids = aws_security_group.dbinstance  # Specify the security group(s) for your RDS instance

  db_subnet_group_name   = aws_db_subnet_group.database_subnet_group.name

  parameter_group_name = "default.mysql5.7"  # Adjust based on your database version

  tags = {
    Name = "YourDatabaseName"
  }
}

