resource "aws_vpc" "main" {
    cidr_block       = "10.0.0.0/16"

    tags {
        Name = "main"
    }
}

resource "aws_subnet" "main" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.100.0/24"

  tags {
    Name = "Main"
  }
}