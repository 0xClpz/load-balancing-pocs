locals {
  forwarding_config = {
    80 = "tcp",
    443 = "tcp"
  }
}

resource "aws_lb" "load_balancer-terraform" {
  name                              = "test-network-lb-fdsfsqfsqa" #can also be obtained from the variable nlb_config
  load_balancer_type                = "network"
  subnet_mapping {
    subnet_id     = local.subnet_a_id
    allocation_id = aws_eip.EIP_ASG.id
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn       = aws_lb.load_balancer-terraform.arn
  port                = 80
  protocol            = "TCP"
  default_action {
    target_group_arn = aws_lb_target_group.tg.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "tg" {
  port                  = 80
  protocol              = "TCP"
  vpc_id                  = local.vpc_id
  target_type             = "instance"
  deregistration_delay    = 90
  health_check {
    interval            = 30
    port                = 80
    protocol            = "TCP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}
