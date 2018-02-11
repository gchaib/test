data "template_file" "container_def" {
  template = "${file("${path.module}/templates/${var.service_name}-${var.tag}.json")}"

  vars {
    tag          = "${var.tag}"
    env          = "${var.env_id}"
    service_name = "${var.service_name}"
    log_group    = "${format("%s-logs","${var.service_name}")}"
  }
}

data "aws_ami" "ec2_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

data "template_file" "script" {
  template = "${file("${path.module}/templates/script.sh.yml")}"

  vars {
    account_id   = "${var.env_id}"
    subnet       = "${join(",", var.subnets)}"
    sg           = "${aws_security_group.service_sg.id}"
    service_name = "${var.service_name}"
  }
}
