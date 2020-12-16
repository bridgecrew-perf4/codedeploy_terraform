resource "aws_iam_role" "cd_svc_role" {
  name = "cd_svc_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF


}

resource "aws_iam_role_policy" "test_policy" {  #<-- For demos only. See https://docs.aws.amazon.com/codedeploy/latest/userguide/getting-started-create-service-role.html
  name = "cd_svc_role_policy"
  role = aws_iam_role.cd_svc_role.id
  policy = <<-EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "*" 
            ],
            "Resource": "*"
        }
    ]
}
  EOF
}