# Create an Identity providers
resource "aws_iam_openid_connect_provider" "github_oidc" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

# Create an IAM role
resource "aws_iam_role" "github_action" {
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.github_permissions.json
}

# Attach the S3 permissions to the IAM role
resource "aws_iam_role_policy" "github_action_policy" {
  role   = aws_iam_role.github_action.id
  policy = data.aws_iam_policy_document.s3_permissions.json
}

# Create an IAM policy that grants S3 permissions
data "aws_iam_policy_document" "s3_permissions" {
  statement {
    actions = [
      "s3:ListAllMyBuckets",
      "s3:GetBucketLocation",
    ]
    resources = [
      "arn:aws:s3:::*",
    ]
  }
}

# Create an IAM policy that grants GitHub permissions
data "aws_iam_policy_document" "github_permissions" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github_oidc.arn]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:euneun316/aws-oidc:*"]

    }
  }
}
