output vpc_id {
    value = aws_vpc.vpc.id
    description = "vpc id"
}

output "public_subnet_id_0" {
    value = aws_subnet.pub-sub[0].id
    description = "subnet id 0"
}

output "public_subnet_id_1" {
    value = aws_subnet.pub-sub[1].id
    description = "subnet id 1"
}