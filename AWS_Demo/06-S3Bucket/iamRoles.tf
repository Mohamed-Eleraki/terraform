resource "aws_iam_role" "s3_full_access_role_01" {
  name = "s3_full_access_role_01"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com" # Change this if the role is for a different AWS service
        }
        Effect = "Allow"
        Sid    = ""
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_full_access_att_01" {
  role       = aws_iam_role.s3_full_access_role_01.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}








resource "aws_iam_role" "s3_full_access_role_02" {
  name = "s3_full_access_role_02"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com" # Change this if the role is for a different AWS service
        }
        Effect = "Allow"
        Sid    = ""
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_full_access_att_02" {
  role       = aws_iam_role.s3_full_access_role_02.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
