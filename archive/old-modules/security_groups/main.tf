# EC2 Security Group (no inline rules)
resource "aws_security_group" "ec2" {
  name_prefix = "${var.project_name}-ec2-"
  description = "Security group for EC2 web instances"
  vpc_id      = var.vpc_id

  tags = {
    Name    = "${var.project_name}-ec2-sg"
    Project = var.project_name
  }

  lifecycle {
    create_before_destroy = true
  }
}

# EC2 Ingress Rule - HTTP
resource "aws_vpc_security_group_ingress_rule" "ec2_http" {
  security_group_id = aws_security_group.ec2.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"

  description = "Allow HTTP from anywhere"

  tags = {
    Name = "${var.project_name}-ec2-http-ingress"
  }
}

# EC2 Ingress Rule - SSH
resource "aws_vpc_security_group_ingress_rule" "ec2_ssh" {
  security_group_id = aws_security_group.ec2.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"

  description = "Allow SSH from anywhere"

  tags = {
    Name = "${var.project_name}-ec2-ssh-ingress"
  }
}

# EC2 Egress Rule - All traffic
resource "aws_vpc_security_group_egress_rule" "ec2_all" {
  security_group_id = aws_security_group.ec2.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"

  description = "Allow all outbound traffic"

  tags = {
    Name = "${var.project_name}-ec2-all-egress"
  }
}