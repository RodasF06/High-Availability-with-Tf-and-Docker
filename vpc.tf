resource "aws_vpc" "main"{
    cidr_block = var.vpc_cidr_block
    instance_tenancy = "default"
    tags = {Name = "main_vpc"}
}

resource "aws_subnet" "public_subnet_a" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_subnet_a_cidr
    availability_zone = "${var.region}a"
    tags = {Name = "Public_subnet_a"} 
}

resource "aws_subnet" "public_subnet_b" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_subnet_b_cidr
    availability_zone = "${var.region}b"
    tags = {Name = "Public_subnet_b"} 
}

resource "aws_subnet" "private_subnet_a" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.private_subnet_a_cidr
    availability_zone = "${var.region}a"
    tags = {Name = "Private_subnet_a"} 
}

resource "aws_subnet" "private_subnet_b" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.private_subnet_b_cidr
    availability_zone = "${var.region}b"
    tags = {Name = "Private_subnet_b"} 
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id
    tags = {Name = "VPC_Ig"} 
}

# Elastic IP
resource "aws_eip" "nat_eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.igw]
}

# NAT Gateway
resource "aws_nat_gateway" "main_nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_a.id
  tags = { Name = "Main_NAT_Gateway" }
  depends_on = [aws_internet_gateway.igw]
}

# Route Tables
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {Name = "Public_Route_Table"}
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main_nat.id
  }
  tags = {Name = "Private_Route_Table"}
}

resource "aws_lb_target_group_attachment" "web_attachment" {
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.private_instance.id
  port             = 80
}

# ASOCIACIONES PÚBLICAS 
resource "aws_route_table_association" "public_assoc_a" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_assoc_b" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public_rt.id
}

# ASOCIACIONES PRIVADAS
resource "aws_route_table_association" "private_assoc_a" {
  subnet_id      = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_assoc_b" {
  subnet_id      = aws_subnet.private_subnet_b.id
  route_table_id = aws_route_table.private_rt.id 
}
