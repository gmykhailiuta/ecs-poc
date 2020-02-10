resource "aws_route_table" "nat-a" {
  vpc_id = "${aws_vpc.main.id}"
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat-a.id}"
  }
}

resource "aws_route_table" "nat-b" {
  vpc_id = "${aws_vpc.main.id}"
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat-b.id}"
  }
}

resource "aws_route_table" "nat-c" {
  vpc_id = "${aws_vpc.main.id}"
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat-c.id}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }
}

resource "aws_route_table_association" "lb-a" {
  subnet_id = "${aws_subnet.lb-a.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "lb-b" {
  subnet_id = "${aws_subnet.lb-b.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "lb-c" {
  subnet_id = "${aws_subnet.lb-c.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "apps-a" {
  subnet_id = "${aws_subnet.apps-a.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "apps-b" {
  subnet_id = "${aws_subnet.apps-b.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "apps-c" {
  subnet_id = "${aws_subnet.apps-c.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "nat-a" {
  subnet_id = "${aws_subnet.nat-a.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "nat-b" {
  subnet_id = "${aws_subnet.nat-b.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "nat-c" {
  subnet_id = "${aws_subnet.nat-c.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "data-a" {
  subnet_id = "${aws_subnet.data-a.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "data-b" {
  subnet_id = "${aws_subnet.data-b.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "data-c" {
  subnet_id = "${aws_subnet.data-c.id}"
  route_table_id = "${aws_route_table.public.id}"
}
