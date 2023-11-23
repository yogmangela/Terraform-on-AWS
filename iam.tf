
# IAM
data "aws_iam_policy" "administrator" {
  name = "AdministratorAccess"
}

data "aws_iam_policy" "ssm_managed" {
  name = "AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy" "database" {
  name = "AmazonRDSDataFullAccess"
}

data "aws_iam_policy" "s3_ReadOnly" {
  name = "AmazonS3ReadOnlyAccess"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}


resource "aws_iam_role" "app" {
  name               = "app"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  managed_policy_arns = [
    data.aws_iam_policy.ssm_managed.arn,
    data.aws_iam_policy.database.arn
  ]
}

resource "aws_iam_role" "web_hosting" {
  name               = "web_hosting"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  managed_policy_arns = [
    data.aws_iam_policy.ssm_managed.arn,
    data.aws_iam_policy.s3_ReadOnly.arn
  ]
}

resource "aws_iam_instance_profile" "app" {
  name = "app-profile"
  role = aws_iam_role.app.name
}

resource "aws_iam_instance_profile" "web_hosting" {
  name = "web-hosting-profile"
  role = aws_iam_role.web_hosting.name
}

