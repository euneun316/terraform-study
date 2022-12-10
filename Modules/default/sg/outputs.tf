output "security_group_id_public" {
  value = aws_security_group.public.id
}

output "security_group_id_private" {
  value = aws_security_group.private.id
}