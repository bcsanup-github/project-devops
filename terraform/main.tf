# 1. Define the Cloud Provider
provider "aws" {
  region = "ap-south-1" # Mumbai region
}

# 2. Create the VPC (The private "fence")
resource "aws_vpc" "devops_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = { Name = "devops-project-vpc" }
}

# 3. Create a Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.devops_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"
}

# 4. Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.devops_vpc.id
}

# 5. Route Table & Association
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.devops_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# 6. Security Group (The Firewall)
resource "aws_security_group" "web_sg" {
  name   = "allow_web_traffic"
  vpc_id = aws_vpc.devops_vpc.id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Frontend"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Backend API"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Grafana Dashboard"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Prometheus UI"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 7. The EC2 Instance
# 7. The EC2 Instance
resource "aws_instance" "devops_server" {
  ami                    = "ami-007020fd9c84e18c7" 
  instance_type          = "t2.micro"             
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = "my-key"

  # ADD THIS BLOCK BELOW
  root_block_device {
    volume_size = 25
    volume_type = "gp3" # gp3 is faster and cheaper than the default gp2
  }

  tags = { Name = "DevOps-Project-Server" }
}
# 8. THE ELASTIC IP (The Permanent Address)
resource "aws_eip" "my_static_ip" {
  instance = aws_instance.devops_server.id
  domain   = "vpc" 
}

# 9. OUTPUTS (This tells you what IP to use)
output "elastic_ip" {
  value = aws_eip.my_static_ip.public_ip
  description = "Use this IP for your React Frontend and GitHub Secrets!"
}