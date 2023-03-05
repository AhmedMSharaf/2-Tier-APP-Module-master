
resource "aws_security_group" "sg-1" {
  name        = "sharaf-security"


  vpc_id = data.aws_vpc.vpc.id
   

  ingress {
    description      = "HTTPS "
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  
  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }


  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  } 

  tags = {
    Name = "allow_http_https"
  }
}



resource "aws_instance" "my-instance" {
  ami           = "ami-0c0933ae5caf0f5f9"
  instance_type = "t2.micro"


  vpc_security_group_ids = [aws_security_group.sg-1.id]

  subnet_id =  aws_subnet.create-subnet["public-subnet"].id

  key_name = "test-keypair.pem"
  
#   the instance name 
  tags = {
    Name = "sharaf-web"
  }
}

# Generate an EIp elastic public ip 
resource  "aws_eip" "my-eip"{
    instance = aws_instance.my-instance.id
    vpc = true
    
}

# upload "terraform.tfstate" file to S3 
terraform {
    backend "s3" {
    bucket = "sharaf-s3-backut"
    key    = "terraform.tfstate"
    region = "eu-central-1"
  }
}
