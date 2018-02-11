output "alb_sg" {
  value = "${aws_security_group.alb_sg.id}"
}

output "service_sg" {
  value = "${aws_security_group.service_sg.id}"
}

output "repo" {
  value = "${aws_ecr_repository.docker_repository.repository_url}"
}

output "service_name" {
  value = "${aws_ecs_service.service.name}"
}

output "cluster_name" {
  value = "${aws_ecs_cluster.cluster.name}"
}
