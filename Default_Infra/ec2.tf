## EIP
# bastion_eip
resource "aws_eip" "bastion_eip" {
  instance = aws_instance.bastion.id # bastion ec2 id
  vpc      = true

  tags = {
    Name = "${var.tags}-bastion-eip"
  }
}

## EC2
# bastion
resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.amazon_linux2_kernel_5.id
  instance_type          = "t3.small"
  key_name               = aws_key_pair.key_pair.key_name
  subnet_id              = element(aws_subnet.pub_sub.*.id, 0) # public-subnet-2a
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  root_block_device {
    volume_type = "gp3"
    volume_size = "10"
  }

  tags = {
    Name = "${var.tags}-bastion"
  }
}

# dev-management
resource "aws_instance" "dev_management_2a" {
  ami                    = data.aws_ami.amazon_linux2_kernel_5.id
  instance_type          = "r5.large"
  key_name               = aws_key_pair.key_pair.key_name
  subnet_id              = element(aws_subnet.dev_pri_sub.*.id, 0) # dev-private-subnet-2a
  vpc_security_group_ids = [aws_security_group.dev_management_sg.id]

  root_block_device {
    volume_type = "gp3"
    volume_size = "100"
  }

  tags = {
    Name = "${var.tags}-dev-management-2a"
  }
}

# dev-service
resource "aws_instance" "dev_service_2a" {
  ami                    = data.aws_ami.amazon_linux2_kernel_5.id
  instance_type          = "t3.medium"
  key_name               = aws_key_pair.key_pair.key_name
  subnet_id              = element(aws_subnet.dev_pri_sub.*.id, 0) # dev-private-subnet-2a
  vpc_security_group_ids = [aws_security_group.dev_service_sg.id]

  root_block_device {
    volume_type = "gp3"
    volume_size = "50"
  }

  tags = {
    Name = "${var.tags}-dev-service-2a"
  }
}

# prd-management
resource "aws_instance" "prd_management_2a" {
  ami                    = data.aws_ami.amazon_linux2_kernel_5.id
  instance_type          = "t3.xlarge"
  key_name               = aws_key_pair.key_pair.key_name
  subnet_id              = element(aws_subnet.prd_pri_sub.*.id, 0) # prd-private-subnet-2a
  vpc_security_group_ids = [aws_security_group.prd_management_sg.id]

  root_block_device {
    volume_type = "gp3"
    volume_size = "100"
  }

  tags = {
    Name = "${var.tags}-prd-management-2a"
  }
}

# prd-service-2a
resource "aws_instance" "prd_service_2a" {
  ami                    = data.aws_ami.amazon_linux2_kernel_5.id
  instance_type          = "t3.xlarge"
  key_name               = aws_key_pair.key_pair.key_name
  subnet_id              = element(aws_subnet.prd_pri_sub.*.id, 0) # prd-private-subnet-2a
  vpc_security_group_ids = [aws_security_group.prd_service_sg.id]

  root_block_device {
    volume_type = "gp3"
    volume_size = "50"
  }

  tags = {
    Name = "${var.tags}-prd-service-2a"
  }
}

# prd-service-2c
resource "aws_instance" "prd_service_2c" {
  ami                    = data.aws_ami.amazon_linux2_kernel_5.id
  instance_type          = "t3.xlarge"
  key_name               = aws_key_pair.key_pair.key_name
  subnet_id              = element(aws_subnet.prd_pri_sub.*.id, 1) # prd-private-subnet-2c
  vpc_security_group_ids = [aws_security_group.prd_service_sg.id]

  root_block_device {
    volume_type = "gp3"
    volume_size = "50"
  }

  tags = {
    Name = "${var.tags}-prd-service-2c"
  }
}
