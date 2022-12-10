output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "pub_sub_ids" {
  value = values(aws_subnet.pub_sub)[*].id
}

output "dev_pri_sub_ids" {
  value = values(aws_subnet.dev_pri_sub)[*].id
}

output "prd_pri_sub_ids" {
  value = values(aws_subnet.prd_pri_sub)[*].id
}

output "nat_eip" {
  value = values(aws_eip.nat_eip)[*].public_ip
}

