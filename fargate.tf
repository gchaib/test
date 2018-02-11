module "fargate" {
  service_name           = "fargate"
  source                 = "modules/ecs"
  number_of_tasks        = "2"
  subnets                = ["${module.network.private_subnets_id}"]
  subnets_public         = ["${module.network.public_subnets_id}"]
  env_id                 = "${var.env_id}"
  vpc_id                 = "${module.network.vpc_id}"
  task_role              = "${module.roles.ecs_task_role_arn}"
  ecs_service_role_arn   = "${module.roles.ecs_service_role_arn}"
  ecs_service_role_name  = "${module.roles.ecs_service_role_name}"
  ecs_autoscale_role_arn = "${module.roles.ecs_autoscale_role_arn}"
  tag                    = "latest"
}

resource "aws_security_group_rule" "alb_to_service_in" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = "${module.fargate.alb_sg}"
  security_group_id        = "${module.fargate.service_sg}"
  description              = "allow all alb traffic to service"
}

resource "aws_security_group_rule" "all_to_alb_in" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${module.fargate.alb_sg}"
  description       = "allow all traffic to alb"
}

resource "aws_security_group_rule" "fargate_e" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${module.fargate.service_sg}"
}

resource "aws_security_group_rule" "fargate_alb_e" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${module.fargate.alb_sg}"
}
