resource "aws_security_group" "ssh" {
  name        = "allow_ssh"
  description = "Allow all inbound SSH traffic"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["${var.current_ip}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "docker" {
  name        = "allow_docker"
  description = "Allow connect to the Docker daemon"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 2376
    to_port     = 2376
    protocol    = "TCP"
    cidr_blocks = ["${var.current_ip}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
