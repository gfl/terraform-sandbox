resource "aws_key_pair" "ssh-gfl" {
  key_name   = "ssh-gfl-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDP/DPiIPrmcjk9Kh0GxYOqnvxoi1goULR92U4V33B3KxXvYhOR/UNZq0ej4C7mfKVW7V3hWpwrY9cW7/4vpNr5kv9FHzScxt5e/GIQKFLQh9Z4N3gtMQOZinwOYRhT1Wzhj2SSmqOfV4CgQGI7UeI4IeIu4xqmHlXtC3Cf1kP6yhLKR3WY6wC1fYB/417jM14KIDKsfpD8+MguMtk9k6/83v5w/AJ8/QBfwTYnYbBskM1VV1G5VVa9bG63IItGDafWL5muHaZNFG7pwAGYYD7sZUlZDK1t6j18lXzsSqh4b1ruPfqYA5IxYBuqZRPyLmEWd2f1tKX537RDviH9CgOFgKKR8uYNaoxhrf903d+mF2xyITyZodU5oCK2myUpofugkByOddSsEphL9UAKDeYDWWYjIItAc/qqgdtQHjYFAnOPV8ZlMrl6dymvcqwiCrojh6rr3rAWugRvdwRoSRTBhFvkDn2FEJCyXBKbiPd3yzIz9VPsVmUBtBjLTzWkm5GbFfeFxzz2wxEPaUwVs5U14ZTeqlxgy8ytLDxQjSHbXzZYyNK+v6oOqJW/Q6pdOb2wTtXIlBoIr3alFC6MjltUKG6J10w1oGppJI5D2NdS9YG0YtpLBo1hxw0vCD9TqsqkxkBowxSfEjLk65dVc1JaIFY/D+xQ+E1LhS2PxCMciQ== graciafdez@gmail.com"
}

resource "aws_instance" "concourse" {
  ami                    = "ami-bbaf0ac2"
  instance_type          = "t2.micro"
  subnet_id              = "${aws_subnet.main.id}"
  vpc_security_group_ids = ["${aws_security_group.ssh.id}", "${aws_security_group.docker.id}"]
  key_name               = "${aws_key_pair.ssh-gfl.key_name}"
  availability_zone      = "${aws_subnet.main.availability_zone}"

  associate_public_ip_address = true

  user_data = "${data.template_file.cloud-config.rendered}"

  tags {
    Name = "Concourse"
  }
}
