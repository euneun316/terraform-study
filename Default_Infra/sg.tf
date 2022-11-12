## Security group
# bastion-sg
resource "aws_security_group" "bastion_sg" {
  # count = length(var.bastion_ip)
  name        = "${var.tags}-bastion-sg"
  description = "${var.tags}-bastion-sg"
  vpc_id      = aws_vpc.vpc.id

  # inbound rule
  dynamic "ingress" {
    for_each = [for s in var.bastion_ingress_rules : {
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

  tags = {
    Name = "${var.tags}-bastion-sg"
  }
}

resource "aws_security_group" "dev_management_sg" {
  name        = "${var.tags}-dev-management-sg"
  description = "${var.tags}-dev-management-sg"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
    description     = "From bastion"
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.management_alb_sg.id]
    description     = "From ALB"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.tags}-dev-management-sg"
  }
}

# dev-service-sg
resource "aws_security_group" "dev_service_sg" {
  name        = "${var.tags}-dev-service-sg"
  description = "${var.tags}-dev-service-sg"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
    description     = "From bastion"
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.service_alb_sg.id]
    description     = "From ALB"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.tags}-dev-service-sg"
  }
}

# prd-management-sg
resource "aws_security_group" "prd_management_sg" {
  name        = "${var.tags}-prd-management-sg"
  description = "${var.tags}-prd-management-sg"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
    description     = "From bastion"
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.management_alb_sg.id]
    description     = "From ALB"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.tags}-prd-management-sg"
  }
}

# prd-service-sg
resource "aws_security_group" "prd_service_sg" {
  name        = "${var.tags}-prd-service-sg"
  description = "${var.tags}-prd-service-sg"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
    description     = "From bastion"
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.service_alb_sg.id]
    description     = "FFrom ALB"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.tags}-prd-service-sg"
  }
}

# service_alb_sg
resource "aws_security_group" "service_alb_sg" {
  name        = "${var.tags}-service-alb-sg"
  description = "${var.tags}-service-alb-sg"
  vpc_id      = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = [for s in var.service_ingress_rules : {
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
    Name = "${var.tags}-service-alb-sg"
  }
}

# management_alb_sg
resource "aws_security_group" "management_alb_sg" {
  name        = "${var.tags}-dev-management-alb-sg"
  description = "${var.tags}-dev-management-alb-sg"
  vpc_id      = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = [for s in var.management_ingress_rules : {
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
    Name = "${var.tags}-management-alb-sg"
  }
}