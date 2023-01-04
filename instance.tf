terraform {
  backend "s3" {
    bucket = "mys3buccc"
    key = "s3_folder1"
    region = "us-east-1"
    dynamodb_table = "dynamodbtableee"
    
  }
}

resource "aws_instance" "web" {
  ami           = "ami-0a6b2839d44d781b2"
  instance_type = "t2.micro"
  key_name = "Import_key"
  vpc_security_group_ids  = [ aws_security_group.sg1.id ]
  associate_public_ip_address = true

  tags = {
    Name = "Instance"
  }
}


  resource "null_resource" "webprovisoner" {
  triggers = {
     running_number = var.web-trigger
      }
  provisioner "remote-exec" {
  connection {
        type = "ssh"
        user = "ubuntu"
        private_key = file("~/.ssh/id_rsa")
        host = aws_instance.web.public_ip 
      }
      inline = [
        "sudo apt update",
        "sudo apt install nginx -y" 
        ]
    }
    depends_on = [ aws_instance.web ]
  }    