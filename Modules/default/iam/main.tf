#######################################
## Identity and Access Management (IAM)

# IAM role
resource "aws_iam_role" "private" {
  name = format("%s-private-role", lower(var.name))

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

# Attaches a Managed IAM Policy to an IAM role
resource "aws_iam_role_policy_attachment" "private_for_s3" {
  role       = aws_iam_role.private.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "private_for_ssm" {
  role       = aws_iam_role.private.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# IAM instance profile
resource "aws_iam_instance_profile" "private" {
  name = format("%s-private", lower(var.name))
  role = aws_iam_role.private.name
}