resource "aws_security_group" "allow_ssh_http" {
  name = "allow-ssh-http-5"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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

resource "aws_instance" "web" {
  ami                    = "ami-0f5ee92e2d63afc18" # ✅ Ubuntu 22.04 LTS (Mumbai region)
  instance_type          = var.instance_type
  key_name               = var.key_name
  security_groups        = [aws_security_group.allow_ssh_http.name]

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install apache2 -y
              echo "<h1>Hello HERE ANIL from Terraform + GitHub CI/CD</h1>" > /var/www/html/index.html
              systemctl start apache2
              systemctl enable apache2
            EOF

  tags = {
    Name = "TerraformWebServer"
  }
}
