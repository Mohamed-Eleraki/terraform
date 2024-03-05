resource "aws_iam_user" "user-Dave" {
  name = "Dave"
  #force_destroy = true
}
/*
resource "aws_iam_access_key" "DaveAccessKey" {
  user = aws_iam_user.user-Dave.name
}
*/



#aws s3api put-object --bucket eraki-s3-dev-01 --key upload.file --body upload.file --profile dave
#aws s3api get-object --bucket eraki-s3-dev-01 --key upload.file upload.file --profile dave
