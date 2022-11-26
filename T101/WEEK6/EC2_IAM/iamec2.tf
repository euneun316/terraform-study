resource "aws_instance" "example" {
  ami           = "ami-0eddbd81024d3fbdd"
  instance_type = "t2.micro"
  key_name      = "${var.tags}-key"
  vpc_security_group_ids      = ["${aws_security_group.stg_mysg.id}"]

  # Attach the instance profile
  iam_instance_profile = aws_iam_instance_profile.instance.name

  tags = {
    Name = "${var.tags}-ec2"
  }
}

# Create an IAM role
resource "aws_iam_role" "instance" {
  name_prefix        = var.name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# Allow the IAM role to be assumed by EC2 instances
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Attach the EC2 admin permissions to the IAM role
resource "aws_iam_role_policy" "example" {
  role   = aws_iam_role.instance.id
  policy = data.aws_iam_policy_document.ec2_admin_permissions.json
}

# Create an IAM policy that grants EC2 admin permissions
data "aws_iam_policy_document" "ec2_admin_permissions" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:*"]
    resources = ["*"]
  }
}

# Create an instance profile with the IAM role attached
resource "aws_iam_instance_profile" "instance" {
  role = aws_iam_role.instance.name
}
