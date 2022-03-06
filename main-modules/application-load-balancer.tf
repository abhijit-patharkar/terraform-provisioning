resource "aws_alb" "ecs-load-balancer" {
    name                = "ecs-load-balancer"
    subnets             = ["${module.network.subnet_id_2}","${module.network.subnet_id_1}"]
    security_groups     = ["${module.network.security_group_id}"]

    tags = {
      Name = "ecs-load-balancer"
    }
}

resource "aws_alb_target_group" "ecs-target-group" {
    depends_on          = [aws_alb.ecs-load-balancer]
    name                = "ecs-target-group"
    port                = "80"
    protocol            = "HTTP"
    vpc_id              = "${module.network.vpc_id}"

    health_check {
      healthy_threshold   = "5"
      unhealthy_threshold = "2"
      interval            = "30"
      matcher             = "200"
      path                = "/"
      port                = "traffic-port"
      protocol            = "HTTP"
      timeout             = "5"
  }

    tags = {
      Name = "ecs-target-group"
    }
}

resource "aws_alb_listener" "alb-listener" {
    load_balancer_arn = "${aws_alb.ecs-load-balancer.arn}"
    port              = "80"
    protocol          = "HTTP"

    default_action {
        target_group_arn = "${aws_alb_target_group.ecs-target-group.arn}"
        type             = "forward"
    }
}

output "ecs-load-balancer-name" {
    value = "${aws_alb.ecs-load-balancer.name}"
}

output "ecs-target-group-arn" {
    value = "${aws_alb_target_group.ecs-target-group.arn}"
}
