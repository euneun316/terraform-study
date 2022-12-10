output "key_pair" {
  value = var.key_name
}

output "public_eip" {
  value = aws_eip.public.public_ip
}