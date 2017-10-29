resource "aws_key_pair" "ssh-gfl" {
  key_name   = "ssh-gfl-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC0I1Pt5alKiSvJM0LVQnQtQr844hS93R5bEgjmePtz5B+EBs4gf6TqmMEd3m6hjJJrO+aMlgkb/L2HaoYPIGK2g17GdidRRATP+F0tpC15mNgz31EW7lYjo5Q0VIBnOcaIHBJ0npzUwgxCKnuLhVPNd987i62UJAhon1wMIVN6gdd06Yssb6ru2HzJ92pqRRZzHTA02Hrlafom6ywJa9X38NWfOlrLC85y1gIBxO47Umhz1afAbk8Me1I+AGLF8QMTEkWFXjI5TseARTlgCyMUUPqzcVoQ7PEjfD249s/5eQ5oisXm6PUnik8a8IaQ3AjAxa0CAPi/IVWqG031fcnR gf186016@MFRGF186016-371"
}

resource "aws_instance" "concourse" {
  ami             = "ami-bbaf0ac2"
  instance_type   = "t2.micro"
  subnet_id       = "${aws_subnet.main.id}"
  security_groups = ["${aws_security_group.ssh.id}"]
  key_name        = "${aws_key_pair.ssh-gfl.key_name}"
  availability_zone = "${aws_subnet.main.availability_zone}"

  associate_public_ip_address = true

  tags {
    Name = "Concourse"
  }
}