resource "aws_security_group" "stg_mysg" {
  name        = "T101 SG"
  description = "T101 Study SG"
}

resource "aws_security_group_rule" "stg_mysginbound" {
  type              = "ingress"
  from_port         = 0
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.stg_mysg.id
}

resource "aws_security_group_rule" "stg_mysgoutbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.stg_mysg.id
}
