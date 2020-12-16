resource "aws_launch_template" "lt" {
  name_prefix   = "foobar"
  image_id      = "ami-09558250a3419e7d0"
  instance_type = "t3.large"
    vpc_security_group_ids = [aws_security_group.allow_http.id]
    
    placement {
    availability_zone = data.aws_availability_zones.available.names[0]
  }
    user_data = filebase64("${path.module}/cdagent.sh")

    key_name="jp2"

    iam_instance_profile {
        name= "demo" #<-- see https://docs.aws.amazon.com/codedeploy/latest/userguide/getting-started-create-iam-instance-profile.html
    }
}

resource "aws_autoscaling_group" "asg" {
  vpc_zone_identifier = [aws_subnet.lab_one.id,aws_subnet.lab_two.id]
  desired_capacity   = 4
  max_size           = 8
  min_size           = 2

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }
}