resource "aws_launch_configuration" "imok_lauchconfig" {
  name_prefix                 = "t101-lauchconfig-"
  image_id                    = data.aws_ami.amazon_linux2.id
  key_name                    = aws_key_pair.key_pair.key_name
  instance_type               = "t2.micro"
  security_groups             = [aws_security_group.imok_sg.id]
  associate_public_ip_address = true

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

  # Required when using a launch configuration with an auto scaling group.
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "imok_asg" {
  name                 = "imok_asg"
  launch_configuration = aws_launch_configuration.imok_lauchconfig.name
  vpc_zone_identifier  = [element(aws_subnet.imok_pub_sub.*.id, 0), element(aws_subnet.imok_pub_sub.*.id, 1)]
  min_size             = 3
  max_size             = 10
  health_check_type    = "ELB"
  target_group_arns    = [aws_lb_target_group.imok_albtg.arn]

  tag {
    key                 = "Name"
    value               = "${var.tags[0]}-terraform-asg"
    propagate_at_launch = true
  }
}
