#  creating a security group that allow http, https traffic to get into the instance

resource "aws_security_group" "sg-2" {
  name        = "sharaf-security"

  vpc_id = data.aws_vpc.vpc.id
   
#  allow RDS traffic
  ingress {
    description      = "RDS"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks = ["10.0.0.0/16"]

  }
  

#  allow all outbound traffic from the ec2 instance
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  } 

  tags = {
    Name = "allow_RDS"
  }
}

resource "aws_db_subnet_group" "sub-gr" {
  name       = "sharaf-sub"
  subnet_ids = [aws_subnet.create-subnet["private-subnet-1"].id, aws_subnet.create-subnet["private-subnet-2"].id]

  tags = {
    Name = "sharaf-subnet"
  }
}


resource "aws_db_instance" "default" {
  allocated_storage    = 10
  db_name              = "sharafDB"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = "sharaf"
  password             = "sharaf123456"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  db_subnet_group_name = "sharaf-sub"
  multi_az = true

  port = 3306
  vpc_security_group_ids = [aws_security_group.sg-2.id]
}
