## Security group
# imok-sg
resource "aws_security_group" "imok_sg" {
  name        = "${var.tags[0]}-imok-sg"
  description = "${var.tags[0]}-imok-sg"
  vpc_id      = aws_vpc.imok_vpc.id

  dynamic "ingress" {
    for_each = [for s in var.imok_ingress_rules : {
      from_port = s.from_port
      to_port   = s.to_port
      desc      = s.desc
      cidrs     = [s.cidr]
    }]
    content {
      from_port        = ingress.value.from_port
      to_port          = ingress.value.to_port
      cidr_blocks      = ingress.value.cidrs
      protocol         = "tcp"
      description      = ingress.value.desc
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.tags[0]}-imok-sg"
  }
}