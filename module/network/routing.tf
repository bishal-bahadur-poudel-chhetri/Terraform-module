resource "aws_route_table" "public_route" {
    vpc_id = aws_vpc.default.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.default.id
    }
    tags = {
    Name        = "${var.vpc_name}-Public-RT"
    environment = var.environment
  }
  
}

resource "aws_route_table_association" "public-subnets" {
    count = length(var.public_subnet_cidr)
    subnet_id = element(aws_subnet.public-subnets.*.id,count.index)
    route_table_id = aws_route_table.public_route.id
  
}

