resource "aws_codedeploy_deployment_config" "cd_depconfig" {
  deployment_config_name = "example-deployment-config"
  minimum_healthy_hosts {
    type  = "HOST_COUNT"
    value = 2
  }
  
}

resource "aws_codedeploy_deployment_group" "blue_group" {
  app_name               = aws_codedeploy_app.cd_app.name
  deployment_group_name  = "group_a"
  service_role_arn       = aws_iam_role.cd_svc_role.arn
  deployment_config_name = aws_codedeploy_deployment_config.cd_depconfig.id

  autoscaling_groups=[aws_autoscaling_group.asg.id]

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN" # <-- Which 'controller' to leveraage
  }

    load_balancer_info {
    target_group_info {
 
        name = aws_lb_target_group.tg.name
     
    }
  }
  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout    = "CONTINUE_DEPLOYMENT" # <-- immediately re-route traffic
    }

    green_fleet_provisioning_option {
      action = "COPY_AUTO_SCALING_GROUP"
    }

    terminate_blue_instances_on_deployment_success {
      action = "TERMINATE"
      termination_wait_time_in_minutes = 20 # <-- blue instance retention time
    }
    
  }
}

