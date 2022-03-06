resource "aws_sns_topic" "alarm" {
name = "alarms-topic"
delivery_policy = <<EOF
{
"http": {
  "defaultHealthyRetryPolicy": {
    "minDelayTarget": 20,
    "maxDelayTarget": 20,
    "numRetries": 3,
    "numMaxDelayRetries": 0,
    "numNoDelayRetries": 0,
    "numMinDelayRetries": 0,
    "backoffFunction": "linear"
  },
  "disableSubscriptionOverrides": false,
  "defaultThrottlePolicy": {
    "maxReceivesPerSecond": 1
  }
}
}
EOF

provisioner "local-exec" {
  command = "aws sns subscribe --topic-arn ${self.arn} --protocol email --notification-endpoint ${var.alarms_email}"
}
}





output "alarm_actions" {
  value = aws_sns_topic.alarm.arn
}


resource "aws_cloudwatch_metric_alarm" "cpu" {
  depends_on = [aws_sns_topic.alarm]
  alarm_name                = "web-cpu-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "LFCPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  alarm_actions             = [ "${aws_sns_topic.alarm.arn}" ]
}

resource "aws_cloudwatch_metric_alarm" "health" {
  depends_on = [aws_sns_topic.alarm]
  alarm_name                = "web-health-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "StatusCheckFailed"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "10"
  alarm_description         = "This metric monitors ec2 health status"
  alarm_actions             = [ "${aws_sns_topic.alarm.arn}" ]


}

resource "aws_cloudwatch_metric_alarm" "xx_anomaly_detection" {
  alarm_name                = "terraform-test-foobar"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = "2"
  threshold_metric_id       = "e1"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  alarm_actions             = [ "${aws_sns_topic.alarm.arn}" ]
  insufficient_data_actions = ["${aws_sns_topic.alarm.arn}" ]


  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "CPUUtilization (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "MyLFmetric"
      namespace   = "AWS/EC2"
      period      = "120"
      stat        = "Average"
      unit        = "Count"


    }
  }
}
