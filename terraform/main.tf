# 1. Define the Cloud Provider
provider "aws" {
  region = "ap-south-1" # Mumbai region for Nepal speed
}

# 2. Create the VPC (The private "fence" for your project)
resource "aws_vpc" "devops_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = { Name = "devops-project-vpc" }
}

# 3. Create a Public Subnet (Where your web server lives)
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.devops_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"
}

# 4. Internet Gateway (The "Front Door" to the internet)
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.devops_vpc.id
}

# 5. Route Table (The "GPS" for traffic to find the internet)
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

# 6. Security Group (The "Firewall")
resource "aws_security_group" "web_sg" {
  name   = "allow_web_traffic"
  vpc_id = aws_vpc.devops_vpc.id

  ingress {
    description = "SSH from my computer"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # In a real job, you'd put your specific IP here
  }

  ingress {
    description = "HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP traffic"
    from_port   = 8000
    to_port     = 8000
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

# 7. The EC2 Instance The actual server
resource "aws_instance" "devops_server" {
  ami           = "ami-007020fd9c84e18c7" 
  instance_type = "t2.micro"             
  subnet_id     = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name      = "my-key" 

  tags = { Name = "DevOps-Project-Server" }
}

output "instance_public_ip" {
  value = aws_instance.devops_server.public_ip
}