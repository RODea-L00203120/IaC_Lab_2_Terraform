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

resource "aws_instance" "web" {
  count                       = var.instance_count
  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_ids[count.index]
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.security_group_id]

  user_data_base64 = base64encode(var.user_data)



  tags = {
    Name      = "${var.project_name}-web-${count.index + 1}"
    Project   = var.project_name
    StudentID = "L00203120"
    AZ        = var.availability_zones[count.index]
  }
}