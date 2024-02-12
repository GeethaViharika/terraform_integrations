# Define VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Define public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
}

# Create internet gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
}

# Attach internet gateway to public subnet
resource "aws_route" "route_to_internet" {
  route_table_id         = aws_subnet.public_subnet.route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}

# Define private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.2.0/24"
}

# Create NAT gateway
resource "aws_nat_gateway" "my_nat_gateway" {
  allocation_id = aws_eip.my_eip.id
  subnet_id     = aws_subnet.private_subnet.id
}

# Define route for private subnet to access internet via NAT gateway
resource "aws_route" "route_to_nat_gateway" {
  route_table_id         = aws_subnet.private_subnet.route_table_id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.my_nat_gateway.id
}

# Define database subnet with restricted access
resource "aws_subnet" "database_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.3.0/24"

  # This subnet does not have a route to the internet
}

# Output VPC ID
output "vpc_id" {
  value = aws_vpc.my_vpc.id
}
