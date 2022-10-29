output "vpc_id" {
  value       = aws_vpc.imok_vpc.id
  description = "vpc id"
}

output "public_subnet_2a_id" {
  value       = aws_subnet.imok_pub_sub[0].id
  description = "public_subnet_2a_id"
}

output "public_subnet_2c_id" {
  value       = aws_subnet.imok_pub_sub[1].id
  description = "public_subnet_2c_id"
}

output "dev_private_subnet_2a_id" {
  value       = aws_subnet.imok_dev_pri_sub[0].id
  description = "dev_private_subnet_2a_id"
}

output "dev_private_subnet_2c_id" {
  value       = aws_subnet.imok_dev_pri_sub[1].id
  description = "dev_private_subnet_2c_id"
}

output "prd_private_subnet_2a_id" {
  value       = aws_subnet.imok_prd_pri_sub[0].id
  description = "prd_private_subnet_2a_id"
}

output "prd_private_subnet_2c_id" {
  value       = aws_subnet.imok_dev_pri_sub[1].id
  description = "prd_private_subnet_2c_id"
}

output "myec2_public_ip" {
  value       = aws_instance.imok_ec2_2a.public_ip
  description = "The public IP of the Instance"
}

output "myalb_dns" {
  value       = aws_lb.imok_alb.dns_name
  description = "The DNS Address of the ALB"
}
