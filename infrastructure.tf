resource "aws_vpc" "vpc" {
  cidr_block              = var.vpc_cidr
  instance_tenancy        = "default"
  enable_dns_hostnames    = true

  tags      = {
    Name    = "${var.project_name}-vpc"
  }
}


resource "aws_internet_gateway" "internet_gateway" {
  vpc_id    = aws_vpc.vpc.id 

  tags      = {
    Name    = "${var.project_name}-igw"
  }
}

resource "aws_subnet" "public_subnet_az1" {
  vpc_id                  = aws_vpc.vpc.id 
  cidr_block              = var.public_subnet_az1_cidr
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags      = {
    Name    = "${var.project_name}-public-subnet-az1"
  }
}

resource "aws_subnet" "public_subnet_az2" {
  vpc_id                  = aws_vpc.vpc.id 
  cidr_block              = var.public_subnet_az2_cidr
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags      = {
    Name    = "${var.project_name}-public-subnet-az2"
  }
}

resource "aws_subnet" "public_subnet_az3" {
  vpc_id                  = aws_vpc.vpc.id 
  cidr_block              = var.public_subnet_az3_cidr
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags      = {
    Name    = "${var.project_name}-public-subnet-az2"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id       = aws_vpc.vpc.id 

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags       = {
    Name     = "${var.project_name}-public-route-table"
  }
}


resource "aws_route_table_association" "public_subnet_az1_route_table_association" {
  subnet_id           = aws_subnet.public_subnet_az1.id 
  route_table_id      = aws_route_table.public_route_table.id 
}


resource "aws_route_table_association" "public_subnet_2_route_table_association" {
  subnet_id           = aws_subnet.public_subnet_az2.id 
  route_table_id      = aws_route_table.public_route_table.id 
}

resource "aws_route_table_association" "public_subnet_3_route_table_association" {
  subnet_id           = aws_subnet.public_subnet_az3.id 
  route_table_id      = aws_route_table.public_route_table.id 
}


resource "aws_subnet" "private_app_subnet_az1" {
  vpc_id                   = aws_vpc.vpc.id 
  cidr_block               = var.private_app_subnet_az1_cidr
  availability_zone        = "us-east-1a"
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "${var.project_name}-private-app-subnet-az1"
  }
}

resource "aws_subnet" "private_app_subnet_az2" {
  vpc_id                   = aws_vpc.vpc.id 
  cidr_block               = var.private_app_subnet_az2_cidr
  availability_zone        = "us-east-1b"
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "${var.project_name}-private-app-subnet-az2"
  }
}

resource "aws_subnet" "private_app_subnet_az3" {
  vpc_id                   = aws_vpc.vpc.id 
  cidr_block               = var.private_app_subnet_az3_cidr
  availability_zone        = "us-east-1a"
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "${var.project_name}-private-app-subnet-az3"
  }
}



resource "aws_eip" "eip_for_nat_gateway_az1" {
  vpc    = true

  tags   = {
    Name = "nat gateway az1 eip"
  }
}

resource "aws_eip" "eip_for_nat_gateway_az2" {
  vpc    = true

  tags   = {
    Name = "nat gateway az2 eip"
  }
}


resource "aws_eip" "eip_for_nat_gateway_az3" {
  vpc    = true

  tags   = {
    Name = "nat gateway az3 eip"
  }
}

resource "aws_nat_gateway" "nat_gateway_az1" {
  allocation_id = aws_eip.eip_for_nat_gateway_az1.id
  subnet_id     = aws_subnet.public_subnet_az1.id

  tags   = {
    Name = "nat gateway az1"
  }

  depends_on = [aws_internet_gateway.internet_gateway]
}

resource "aws_nat_gateway" "nat_gateway_az2" {
  allocation_id = aws_eip.eip_for_nat_gateway_az2.id
  subnet_id     = aws_subnet.public_subnet_az2.id

  tags   = {
    Name = "nat gateway az2"
  }

  depends_on = [aws_internet_gateway.internet_gateway]
}

resource "aws_nat_gateway" "nat_gateway_az3" {
  allocation_id = aws_eip.eip_for_nat_gateway_az3.id
  subnet_id     = aws_subnet.public_subnet_az3.id

  tags   = {
    Name = "nat gateway az3"
  }

  depends_on = [aws_internet_gateway.internet_gateway]
}

resource "aws_route_table" "private_route_table_az1" {
  vpc_id            = aws_vpc.vpc.id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat_gateway_az1.id
  }

  tags   = {
    Name = "private route table az1"
  }
}

resource "aws_route_table_association" "private_app_subnet_az1_route_table_az1_association" {
  subnet_id         = aws_subnet.private_app_subnet_az1.id
  route_table_id    = aws_route_table.private_route_table_az1.id 
}


resource "aws_route_table" "private_route_table_az2" {
  vpc_id            = aws_vpc.vpc.id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat_gateway_az2.id
  }

  tags   = {
    Name = "private route table az2"
  }
}

resource "aws_route_table_association" "private_app_subnet_az2_route_table_az2_association" {
  subnet_id         = aws_subnet.private_app_subnet_az2.id
  route_table_id    = aws_route_table.private_route_table_az2.id
}

resource "aws_route_table" "private_route_table_az3" {
  vpc_id            = aws_vpc.vpc.id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat_gateway_az3.id
  }

  tags   = {
    Name = "private route table az3"
  }
}

resource "aws_route_table_association" "private_app_subnet_az3_route_table_az2_association" {
  subnet_id         = aws_subnet.private_app_subnet_az3.id
  route_table_id    = aws_route_table.private_route_table_az3.id
}



data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}


data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]  # Canonical account ID for Ubuntu AMIs

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


resource "aws_instance" "jenkins_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.large"
  subnet_id              = aws_subnet.public_subnet_az2.id
  key_name               = "postgreskey"
  user_data              = file("ngnixinstall.sh")
  vpc_security_group_ids = [aws_security_group.ngnix_security_group.id]
  tags = {
    Name    = "${var.project_name}-Server1"
  }
}

resource "aws_network_interface" "main_network_interface_jenkins" {
  subnet_id = aws_subnet.public_subnet_az2.id
  tags      = {
    Name    = "${var.project_name}-network-interface1"
  }
}



resource "aws_instance" "Nexus_server" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.medium"
  subnet_id = aws_subnet.public_subnet_az1.id
  key_name = "postgreskey"
  vpc_security_group_ids = [aws_security_group.ngnix_security_group.id]
  user_data              = file("ngnixinstall.sh")
  tags = {
    Name    = "${var.project_name}-Server2"
  }
}

resource "aws_network_interface" "main_network_interface-Nexus" {
  subnet_id   = aws_subnet.public_subnet_az1.id

  tags = {
    Name    = "${var.project_name}-network_interface2"
  }
}