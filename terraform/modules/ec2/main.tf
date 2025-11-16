# Get latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# EC2 Instance 1 (AZ1)
resource "aws_instance" "web1" {
  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_ids[0]
  associate_public_ip_address = true

  tags = {
    Name = "${var.project_name}-web1"
    AZ   = var.availability_zones[0]
  }
}

# EC2 Instance 2 (AZ2)
resource "aws_instance" "web2" {
  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_ids[1]
  associate_public_ip_address = true

  tags = {
    Name = "${var.project_name}-web2"
    AZ   = var.availability_zones[1]
  }
}