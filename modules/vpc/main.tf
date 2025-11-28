resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    { Name = "eks-vpc" },
    var.tags
  )
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    { Name = "eks-igw" },
    var.tags
  )
}

# --- Public Subnets ---
resource "aws_subnet" "public" {
  for_each = toset(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value
  map_public_ip_on_launch = true

  availability_zone = element(data.aws_availability_zones.available.names, index(var.public_subnet_cidrs, each.value))

  tags = merge(
    { Name = "public-${each.value}" },
    var.tags
  )
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    { Name = "public-rt" },
    var.tags
  )
}

resource "aws_route" "default_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# --- NAT Gateway ---
resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? 1 : 0

  vpc = true

  tags = merge(
    { Name = "eks-nat-eip" },
    var.tags
  )
}

resource "aws_nat_gateway" "nat" {
  count = var.enable_nat_gateway ? 1 : 0

  allocation_id = aws_eip.nat[0].id
  subnet_id     = element(aws_subnet.public[*].id, 0)

  tags = merge(
    { Name = "eks-nat" },
    var.tags
  )
}

# --- Private Subnets ---
resource "aws_subnet" "private" {
  for_each = toset(var.private_subnet_cidrs)

  vpc_id     = aws_vpc.this.id
  cidr_block = each.value

  availability_zone = element(data.aws_availability_zones.available.names, index(var.private_subnet_cidrs, each.value))

  tags = merge(
    { Name = "private-${each.value}" },
    var.tags
  )
}

# Private Route Table
resource "aws_route_table" "private" {
  count = var.enable_nat_gateway ? 1 : 0
  vpc_id = aws_vpc.this.id

  tags = merge(
    { Name = "private-rt" },
    var.tags
  )
}

resource "aws_route" "private_nat" {
  count = var.enable_nat_gateway ? 1 : 0

  route_table_id         = aws_route_table.private[0].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[0].id
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id = each.value.id
  route_table_id = var.enable_nat_gateway ? aws_route_table.private[0].id : null
}

# Availability Zones
data "aws_availability_zones" "available" {
  state = "available"
}
