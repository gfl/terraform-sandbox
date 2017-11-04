output "concourse_ip" {
  value = "${aws_instance.concourse.public_ip}"
}
