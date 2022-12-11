output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "nat_eip" {
  value = module.vpc.nat_eip
}

output "key_pair" {
  value = module.ec2.key_pair
}

output "public_eip" {
  value = module.ec2.public_eip
}

output "ec2_private_id" {
  value = module.ec2.ec2_private_id
}