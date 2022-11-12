output "address" {
  value       = aws_db_instance.myrds.address
  description = "Connect to the database at this endpoint"
}

output "port" {
  value       = aws_db_instance.myrds.port
  description = "The port the database is listening on"
}

output "vpcid" {
  value       = aws_vpc.myvpc.id
  description = "My VPC Id"
}
