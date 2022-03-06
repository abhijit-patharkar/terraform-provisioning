resource "aws_autoscaling_group" "ecs-autoscaling-group" {
    name                        = "LF-ASG"
    max_size                    = 5
    min_size                    = 1
    desired_capacity            = 3
    vpc_zone_identifier         = ["${module.network.subnet_id_2}", "${module.network.subnet_id_out}"]
    launch_configuration        = "${aws_launch_configuration.ecs-launch-configuration.name}"
    health_check_type           = "ELB"
}


resource "aws_appautoscaling_target" "target" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.LF-ecs-cluster.name}/${aws_ecs_service.LF_ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  role_arn           = "${module.iam.role_arn}"
  min_capacity       = 1
  max_capacity       = 4
}

resource "aws_autoscaling_policy" "up_" {
  name                   = "LF_ASG_POLICY"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.ecs-autoscaling-group.name}"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 85
  }
}



resource "aws_appautoscaling_policy" "up" {
  name                    = "LF_scale_up"
  service_namespace       = "ecs"
  resource_id             = "service/${aws_ecs_cluster.LF-ecs-cluster.name}/${aws_ecs_service.LF_ecs_service.name}"
  scalable_dimension      = "ecs:service:DesiredCount"


  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment = 1
    }
  }

  depends_on = [aws_appautoscaling_target.target]
}

resource "aws_appautoscaling_policy" "down" {
  name                    = "LF_scale_down"
  service_namespace       = "ecs"
  resource_id             = "service/${aws_ecs_cluster.LF-ecs-cluster.name}/${aws_ecs_service.LF_ecs_service.name}"
  scalable_dimension      = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment = -1
    }
  }

  depends_on = [aws_appautoscaling_target.target]
}


resource "aws_cloudwatch_metric_alarm" "service_cpu_high" {
  alarm_name          = "openjobs_web_cpu_utilization_high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "85"

  dimensions = {
    ClusterName = "${aws_ecs_cluster.LF-ecs-cluster.name}"
    ServiceName = "${aws_ecs_service.LF_ecs_service.name}"
  }

  alarm_actions = ["${aws_appautoscaling_policy.up.arn}"]
  ok_actions    = ["${aws_appautoscaling_policy.down.arn}"]
}
