######### LAMBDA SG #########
resource "aws_security_group" "lambda-sg" {
    name   = "${var.Application}-${var.Environment}-lambda-aurora"
    vpc_id = "${var.vpc_id}"

    egress{
        from_port = "53"
        to_port   = "53"
        protocol  = "udp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags {
        Name            = "${var.Application}-${var.Environment}-aurora"
        resource-group  = "Lambda"
        application     = "${var.Application}"
        owner           = "${var.Owner}"
        description     = "${var.Application}-${var.Environment}"
        builder         = "${var.Tag_builder}"
    }
}

resource "aws_security_group_rule" "anytolambdainbound" {
  type                  = "ingress"
  from_port             = 0
  to_port               = 65535
  protocol              = "tcp"
  security_group_id     = "${aws_security_group.lambda-sg.id}"
  source_security_group_id = "${aws_security_group.aurorarewards-sg.id}"
}

resource "aws_security_group_rule" "LambdatoAuroraoutbound" {
  type                  = "egress"
  from_port             = "${var.db_port}"
  to_port               = "${var.db_port}"
  protocol              = "tcp"
  security_group_id     = "${aws_security_group.lambda-sg.id}"
  source_security_group_id = "${aws_security_group.aurorarewards-sg.id}"
}

########## AURORA SG ###########

resource "aws_security_group" "aurorarewards-sg" {
    name   = "${var.Application}-${var.Environment}-aurora-sg"
    vpc_id = "${var.vpc_id}"

    egress{
        from_port = "443"
        to_port   = "443"
        protocol  = "tcp"
        cidr_blocks = ["pl-6da54004"] #["${aws_vpc_endpont.rewards_s3_endpoint.id}"]
    }

    tags {
        Name            = "${var.Application}-${var.Environment}-aurora"
        resource-group  = "Aurora"
        application     = "${var.Application}"
        owner           = "${var.Owner}"
        description     = "${var.Application}-${var.Environment}"
        builder         = "${var.Tag_builder}"
    }
}


# Aurora sg Lambda inbound rule
resource "aws_security_group_rule" "auroratolambdainbound" {
  type                  = "ingress"
  from_port             = "${var.db_port}"
  to_port               = "${var.db_port}"
  protocol              = "tcp"
  security_group_id     = "${aws_security_group.aurorarewards-sg.id}"
  source_security_group_id = "${aws_security_group.lambda-sg.id}"
}

resource "aws_security_group_rule" "LambdatoAuroraoutbound" {
  type                  = "egress"
  from_port             = 0
  to_port               = 65535
  protocol              = "tcp"
  security_group_id     = "${aws_security_group.aurorarewards-sg.id}"
  source_security_group_id = "${aws_security_group.lambda-sg.id}"
}
