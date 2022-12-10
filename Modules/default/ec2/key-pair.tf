######################################
## Key-Pair

# Generates a secure private key and encodes it as PEM
resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
# Create the Key Pair
resource "aws_key_pair" "key_pair" {
  key_name   = "${var.name}-key"
  public_key = tls_private_key.key_pair.public_key_openssh
}
# Save Pem Key
resource "local_file" "ssh_key" {
  filename = "${path.module}/${aws_key_pair.key_pair.key_name}.pem"
  content  = tls_private_key.key_pair.private_key_pem
}