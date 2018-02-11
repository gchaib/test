variable "vpc_id" {}

variable "service_name" {}

variable "ecs_service_role_arn" {}

variable "ecs_service_role_name" {}

variable "task_role" {}

variable "number_of_tasks" {}

variable "health_path" {
  default = "/"
}

variable "env_id" {}

variable "tag" {
  default = "stable"
}

variable "fargate_cpu" {
  default = "256"
}

variable "fargate_memory" {
  default = "512"
}

variable "subnets" {
  type = "list"
}

variable "subnets_public" {
  type = "list"
}

variable "ecs_autoscale_role_arn" {}

variable "file" {
  default = "script.sh"
}
