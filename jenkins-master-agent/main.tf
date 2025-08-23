#vpc-dv
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = "true"
  tags = {
      Name = "jenkins-vpc" 
  } 
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
      Name = "jenkins-IGW"
    }
} 

resource "aws_subnet" "public_subnet_ids" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.99.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
      Name = "jenkins-sn"
    }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
      Name = "jenkins-route-table"
    }
}

resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
}
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet_ids.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "main" {
  name        = "jenkins-security-group"
  description = "jenkins-security-group for allowing ingress & egress"
  vpc_id      = aws_vpc.main.id
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
 }
}


resource "aws_security_group_rule" "jenkins_sg_rule" {
  #count = length(var.allowed_ports)
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.main.id
  cidr_blocks      = ["0.0.0.0/0"]

 
}

resource "aws_instance" "jenkins_servers" {
  count = length(var.jenkins_server)
  ami           = local.ami_id
  #instance_type = "t2.micro"
  instance_type = "t3.small"
  root_block_device {
    volume_size = 50
    volume_type = "gp3" # or "gp2", depending on your preference
    delete_on_termination = true
  }
  vpc_security_group_ids = [aws_security_group.main.id]
  subnet_id = aws_subnet.public_subnet_ids.id

  tags ={
        Name = var.jenkins_server[count.index]
    }
  user_data = file("server.sh")
  
}

resource "aws_instance" "jenkins_agent" {
  count = length(var.jenkins_agent)
  ami           = local.ami_id
  #instance_type = "t2.micro"
  instance_type = "t3.small"
  root_block_device {
    volume_size = 50
    volume_type = "gp3" # or "gp2", depending on your preference
    delete_on_termination = true
  }
  vpc_security_group_ids = [aws_security_group.main.id]
  subnet_id = aws_subnet.public_subnet_ids.id

  tags ={
        Name = var.jenkins_agent[count.index]
    }
  user_data = file("agent.sh")
  
}


