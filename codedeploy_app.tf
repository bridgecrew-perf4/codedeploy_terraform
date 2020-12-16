resource "aws_codedeploy_app" "cd_app" {
  compute_platform = "Server"
  name             = "DemoApplication"
}