resource "aws_db_subnet_group" "mydbsubnet" {
  name       = "mydbsubnetgroup"
  subnet_ids = [aws_subnet.mysubnet3.id, aws_subnet.mysubnet4.id]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "myrds" {
  identifier_prefix      = "t101"
  engine                 = "mysql"
  allocated_storage      = 10
  instance_class         = "db.t2.micro"
  db_subnet_group_name   = aws_db_subnet_group.mydbsubnet.name
  vpc_security_group_ids = [aws_security_group.mysg2.id]
  skip_final_snapshot    = true

  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
}
