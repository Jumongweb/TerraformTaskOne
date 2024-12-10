provider "aws" {
  region = "us-east-1"
}

data "aws_security_group" "existing_web_sg" {
  filter {
    name   = "group-name"
    values = ["web_sg"]
  }

  filter {
    name   = "vpc-id"
    values = ["vpc-0f989580cd63caf96"]
  }
}

resource "aws_instance" "web" {
  ami           = "ami-0866a3c8686eaeeba"
  instance_type = "t2.micro"
  key_name      = "terraform-key"

  vpc_security_group_ids = [data.aws_security_group.existing_web_sg.id]

  tags = {
    Name = "TerraformInstance"
  }

  # Run some initial setup commands (if necessary)
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y docker
              sudo service docker start
              sudo usermod -a -G docker ec2-user
              docker run -d -p 80:80 jumongweb/internship-task-one:latest  
              EOF
}

