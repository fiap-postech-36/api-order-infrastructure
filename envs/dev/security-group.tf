resource "aws_security_group" "sg_cluster" {
  name   = "${var.project_name}-sg"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "cluster_in" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg_cluster.id
}

resource "aws_security_group_rule" "cluster_amqp" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg_cluster.id
}

resource "aws_security_group_rule" "cluster_app" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg_cluster.id
}

resource "aws_security_group_rule" "cluster_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg_cluster.id
}