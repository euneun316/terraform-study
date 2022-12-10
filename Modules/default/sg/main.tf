######################################
## Security Groups

locals {
  public_sg  = format("%s-%s-sg", var.name, "public")
  private_sg = format("%s-%s-sg", var.name, "private")
}


# public sg
resource "aws_security_group" "public" {
  name        = local.public_sg
  description = "public security group for ${var.name}"
  vpc_id      = var.vpc_id


  # inbound rule
  dynamic "ingress" {
    for_each = [for s in var.public_ingress_rules : {
      from_port = s.from_port
      to_port   = s.to_port
      desc      = s.desc
      cidrs     = [s.cidr]
    }]
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      cidr_blocks = ingress.value.cidrs
      protocol    = "tcp"
      description = ingress.value.desc
    }
  }

  # self refer
  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    self        = true
    description = "Self Refer"
  }

  # outbound rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      Name = local.public_sg
    },
    var.tags
  )
}

# private sg
resource "aws_security_group" "private" {
  name        = local.private_sg
  description = "private security group for ${var.name}"
  vpc_id      = var.vpc_id


  # inbound rule
  dynamic "ingress" {
    for_each = [for s in var.private_ingress_rules : {
      from_port = s.from_port
      to_port   = s.to_port
      desc      = s.desc
      cidrs     = [s.cidr]
    }]
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      cidr_blocks = ingress.value.cidrs
      protocol    = "tcp"
      description = ingress.value.desc
    }
  }

  # outbound rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      Name = local.private_sg
    },
    var.tags
  )
}