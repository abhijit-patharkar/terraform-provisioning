# Availability zones
data "aws_availability_zones" "available" {}

# VPC
resource "aws_vpc" "LF-VPC" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = var.tenancy
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = {
    Name = "LF-VPC"
  }
}

# Subnets
resource "aws_subnet" "main-private-1" {
  count                   = length(data.aws_availability_zones.available.names)
  vpc_id                  = aws_vpc.LF-VPC.id
  cidr_block              = "10.0.${31 + count.index}.0/19"
  map_public_ip_on_launch = "false"
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "LF-Private-Subnet ${count.index}"
  }
}

output "vpc_id" {
  value = aws_vpc.LF-VPC.id
}

output "subnet_id_1" {
  value = aws_subnet.main-public-1.1.id
}

output "subnet_id_out" {
  value = aws_subnet.main-private-1.0.id
}

output "subnet_id_2" {
  value = aws_subnet.main-public-1.0.id
}

output "security_group_id"{
  value = aws_security_group.web.id
}

resource "aws_subnet" "main-public-1" {
  count                   = length(data.aws_availability_zones.available.names)
  vpc_id                  = aws_vpc.LF-VPC.id
  cidr_block              = "10.0.${64 + count.index}.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "LF-Public-Subnet ${count.index}"
  }
}


# Internet Gateway for subnet
resource "aws_internet_gateway" "main-gw" {
  vpc_id = aws_vpc.LF-VPC.id
  tags = {
    Name = "LF-Internet-Gateway"
  }
}

# route tables
resource "aws_route_table" "main-public" {
  vpc_id = aws_vpc.LF-VPC.id
  route {
    cidr_block = var.route_cidr_block
    gateway_id = aws_internet_gateway.main-gw.id
  }

  tags = {
    Name = "LF-Route-Table"
  }
}

resource "aws_route_table_association" "vpc-route-table-association1" {
    subnet_id      = "${aws_subnet.main-public-1.0.id}"
    route_table_id = "${aws_route_table.main-public.id}"
}

resource "aws_route_table_association" "vpc-route-table-association2" {
    subnet_id      = "${aws_subnet.main-private-1.0.id}"
    route_table_id = "${aws_route_table.main-public.id}"
}
# route associations public
/*resource "aws_route_table_association" "main-public-1-b" {
  subnet_id      = aws_subnet.main-public-1.id
  route_table_id = aws_route_table.main-public.id
  depends_on = [
    aws_subnet.main-public-1,
    aws_route_table.main-public
  ]
}*/
