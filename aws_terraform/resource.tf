# key pair
resource "aws_key_pair" "k8s_ho_admin" {
  key_name = "k8s_ho"
  public_key = file("~/.ssh/k8s-ho.pub")
}


# security group
data "aws_security_group" "default" {
  name = "default"
}

resource "aws_security_group" "k8s-group" {
  name = "k8s-manifest_group"
  description = "Required port open policy in k8s-ho kubernetes cluster"
  ingress {
    from_port = 12340
    to_port = 12343
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# instance
resource "aws_instance" "master" {
  ami = "ami-051d287d02a19035f" # ubuntu 20.04 64bit
  instance_type = "t2.medium"
  root_block_device {
    volume_size = 30
  }
  key_name = aws_key_pair.k8s_ho_admin.key_name
  vpc_security_group_ids = [
    aws_security_group.k8s-group.id,
    data.aws_security_group.default.id
  ]
  user_data = <<-EOF
              #!/bin/bash
              git clone https://github.com/k8s-ho/k8s-ho_setup
              cd k8s-ho_setup
              sudo touch test.txt
              EOF
}
