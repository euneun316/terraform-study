output "key_pair" {
  value = var.key_name
}

output "public_eip" {
  value = aws_eip.public.public_ip
}

output "ec2_private_id" {
  value = aws_instance.private.id
}