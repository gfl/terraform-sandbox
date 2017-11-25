output "concourse_ip" {
  value = "${aws_instance.concourse.public_ip}"
}

output "name_servers" {
  value = "${aws_route53_zone.primary.name_servers}"
}
