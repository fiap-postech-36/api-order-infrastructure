variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project Name"
  type        = string
  default = "ms-order"
}

variable "DEFAULT_PASS" {
  description = "Default password for RabbitMQ"
  type        = string
  default = "GpP36_Fiap@2024!"
}

variable "DEFAULT_USER" {
  description = "Default user for RabbitMQ"
  type        = string
  default = "fiap"
}

variable "RABBITMQ_HOST" {
  description = "RabbitMQ Host"
  type        = string
  default = "http://af4b45659baf047e49724279ab7d29eb-1909975876.us-east-1.elb.amazonaws.com"
}