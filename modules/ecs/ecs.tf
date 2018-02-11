resource "aws_cloudwatch_log_group" "log_group" {
  name = "${format("%s-logs","${var.service_name}")}"
}

resource "aws_ecr_repository" "docker_repository" {
  name = "${var.service_name}"
}

resource "aws_ecs_cluster" "cluster" {
  name = "${format("%s","${var.service_name}")}"

  lifecycle {
    ignore_changes = ["name"]
  }
}

resource "aws_ecs_task_definition" "task" {
  family                   = "${format("%s-%s","${var.service_name}","${var.tag}")}"
  container_definitions    = "${data.template_file.container_def.rendered}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "${var.fargate_cpu}"
  memory                   = "${var.fargate_memory}"
  task_role_arn            = "${var.task_role}"
  execution_role_arn       = "${var.task_role}"
}

resource "aws_security_group" "service_sg" {
  name   = "${format("%s-sg","${var.service_name}")}"
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "${format("%s-sg","${var.service_name}")}"
  }
}

resource "aws_security_group" "alb_sg" {
  name   = "${format("%s-alb-sg","${var.service_name}")}"
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "${format("%s-alb-sg","${var.service_name}")}"
  }
}

resource "aws_alb_target_group" "tg" {
  name        = "${format("%s-tg","${var.service_name}")}"
  port        = "80"
  protocol    = "HTTP"
  vpc_id      = "${var.vpc_id}"
  target_type = "ip"

  health_check = {
    path    = "${var.health_path}"
    matcher = "200,204"
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = ["aws_alb_target_group.tg"]
}

resource "aws_alb_listener" "alb_listener_HTTP" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.tg.arn}"
    type             = "forward"
  }

  depends_on = ["aws_alb_target_group.tg"]
}

resource "aws_alb" "alb" {
  name                       = "${lower(format("%s-alb","${var.service_name}"))}"
  security_groups            = ["${aws_security_group.alb_sg.id}"]
  subnets                    = ["${var.subnets_public}"]
  enable_deletion_protection = false
  depends_on                 = ["aws_alb_target_group.tg"]
}

resource "aws_ecs_service" "service" {
  name                               = "${var.service_name}"
  cluster                            = "${aws_ecs_cluster.cluster.id}"
  task_definition                    = "${aws_ecs_task_definition.task.arn}"
  launch_type                        = "FARGATE"
  desired_count                      = "${var.number_of_tasks}"
  deployment_maximum_percent         = "200"
  deployment_minimum_healthy_percent = "50"

  load_balancer {
    container_name   = "${var.service_name}"
    container_port   = "80"
    target_group_arn = "${aws_alb_target_group.tg.arn}"
  }

  network_configuration {
    security_groups  = ["${aws_security_group.service_sg.id}"]
    subnets          = ["${var.subnets}"]
    assign_public_ip = "true"
  }

  provisioner "local-exec" {
    command = "${format("cat <<\"EOF\" > \"%s\"\n%s\nEOF", var.file, data.template_file.script.rendered)}"
  }

  provisioner "local-exec" {
    command = "chmod +x script.sh;./script.sh"
  }

  depends_on = ["aws_alb_listener.alb_listener_HTTP"]
}
