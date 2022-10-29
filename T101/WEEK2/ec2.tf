## amazon linux2 ami latest kernel-5
data "aws_ami" "amazon_linux2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

## EIP
# public_eip
resource "aws_eip" "public_eip" {
  instance = aws_instance.imok_ec2_2a.id # public ec2 id
  vpc      = true

  tags = {
    Name = "${var.tags[0]}-public-eip"
  }
}

## EC2
# imok ec2
resource "aws_instance" "imok_ec2_2a" {
  ami                    = data.aws_ami.amazon_linux2.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.key_pair.key_name
  subnet_id              = element(aws_subnet.imok_pub_sub.*.id, 0) # public-subnet-2a
  vpc_security_group_ids = [aws_security_group.imok_sg.id]

  root_block_device {
    volume_type = "gp3"
    volume_size = "10"
  }

  user_data = <<-EOF
              #!/bin/bash
              wget https://busybox.net/downloads/binaries/1.31.0-defconfig-multiarch-musl/busybox-x86_64
              mv busybox-x86_64 busybox
              chmod +x busybox
              RZAZ=$(curl http://169.254.169.254/latest/meta-data/placement/availability-zone-id)
              IID=$(curl 169.254.169.254/latest/meta-data/instance-id)
              LIP=$(curl 169.254.169.254/latest/meta-data/local-ipv4)
              echo "<h1>RegionAz($RZAZ) : Instance ID($IID) : Private IP($LIP) : Web Server</h1>" > index.html
              nohup ./busybox httpd -f -p 80 &
              EOF

  user_data_replace_on_change = true

  tags = {
    Name = "${var.tags[0]}-imok-ec2-2a"
  }
}
