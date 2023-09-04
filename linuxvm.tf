# Creates an AWS Linux VM
resource "aws_instance" "argo_instance" {
  ami                    = var.ami
  subnet_id = aws_subnet.argo_subnet.id  
  associate_public_ip_address = true  
  instance_type          = var.instance_type
  key_name = var.keys
  vpc_security_group_ids = [aws_security_group.argo_sg.id]
  user_data              = <<-EOF
                 #!/bin/bash
                 sudo yum update
                 sudo yum install wget
                EOF
  user_data_replace_on_change = true
  tags = {
    Name = "Argo_EC2"
  }
}
