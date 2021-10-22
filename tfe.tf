resource "aws_security_group" "tfe" {
  name        = "${var.name}-tfe-sg"
  description = "private tfeserver"
  vpc_id      = aws_vpc.hashicorp_vpc.id
}

resource "aws_security_group_rule" "tfe-http" {
  security_group_id = aws_security_group.tfe.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "tfe-https" {
  security_group_id = aws_security_group.tfe.id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "tfe-ssh" {
  security_group_id = aws_security_group.tfe.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "tfe-admin" {
  security_group_id = aws_security_group.tfe.id
  type              = "ingress"
  from_port         = 8800
  to_port           = 8800
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}


resource "aws_security_group_rule" "tfe-egress" {
  security_group_id = aws_security_group.tfe.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}


output "tfe_asg_id" {
  value = aws_security_group.tfe.id
}