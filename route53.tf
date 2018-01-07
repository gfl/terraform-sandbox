resource "aws_route53_zone" "primary" {
  name = "gfl.keytwine.com"
}

resource "aws_route53_record" "dev-ns" {
  zone_id = "${aws_route53_zone.primary.zone_id}"
  name    = "gfl.keytwine.com"
  type    = "NS"
  ttl     = "30"

  records = [
    "${aws_route53_zone.primary.name_servers.0}",
    "${aws_route53_zone.primary.name_servers.1}",
    "${aws_route53_zone.primary.name_servers.2}",
    "${aws_route53_zone.primary.name_servers.3}",
  ]
}

resource "aws_route53_record" "www" {
  zone_id = "${aws_route53_zone.primary.zone_id}"
  name    = "www.gfl.keytwine.com"
  type    = "CNAME"
  ttl     = "300"
  records = ["gfl.github.io"]
}

resource "aws_route53_record" "concourse" {
  zone_id = "${aws_route53_zone.primary.zone_id}"
  name    = "concourse.gfl.keytwine.com"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.concourse.public_ip}"]
}