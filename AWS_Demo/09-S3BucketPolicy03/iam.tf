resource "aws_iam_user" "Mohamed" {
    name = "Mohamed"
}


resource "aws_iam_user" "Taha" {  # (i.e. Consider it as external access)
    name = "Taha"
}

resource "aws_iam_user" "Mostafa" {
    name = "Mostafa"
}

# Create IAM Role for Taha - (i.e. Consider it as external access)
resource "aws_iam_role" "iam_role_get_s3_taha" {
  name = "s3_get_access_role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "114",
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Principal": {
                "AWS": "${aws_iam_user.Taha.arn}"
            }
        }
    ]
}
EOF
}

# Create S3 get policy
data "aws_iam_policy_document" "s3_get_access_policy_document" {
  statement {
    sid = "115"
    effect = "Allow"   

    actions = [ 
      "s3:GetObject"
     ]

     resources = [ 
      "${aws_s3_bucket.s3_01.arn}/mostafa/*"
      ]
  }
}

resource "aws_iam_policy" "holds_s3_get_policy" {
  name = "holds_s3_get_policy"
  policy = data.aws_iam_policy_document.s3_get_access_policy_document.json
}

# attche s3 get policy to the role
resource "aws_iam_role_policy_attachment" "attach_s3_get_role" {
  role = aws_iam_role.iam_role_get_s3_taha.name
  policy_arn = aws_iam_policy.holds_s3_get_policy.arn
}

# you must put the role into the user profile  | https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-role.html
# [profile Taha]
# region = us-east-1
# output = json

# [profile TahaAdmin]
# role_arn = arn:aws:iam::891377122503:role/s3_get_access_role
# source_profile = Taha