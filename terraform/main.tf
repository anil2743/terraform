resource "aws_security_group" "allow_ssh_http" {
  name_prefix = "allow-ssh-http-"

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
  ami                    = "ami-0f5ee92e2d63afc18" # Ubuntu 22.04 LTS - ap-south-1
  instance_type          = var.instance_type
  key_name               = var.key_name
  security_groups        = [aws_security_group.allow_ssh_http.name]
  user_data_replace_on_change = true

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install apache2 -y
              echo "<h1>Hello FROM USER DATA (first run only)</h1>" > /var/www/html/index.html
              systemctl start apache2
              systemctl enable apache2
            EOF

  tags = {
    Name = "TerraformWebServer"
  }

  lifecycle {
    ignore_changes = [user_data]
  }

  provisioner "remote-exec" {
    inline = [
      "echo '<h1>UPDATED PAGE — from Anil Yadav via remote-exec</h1>' | sudo tee /var/www/html/index.html"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("${path.module}/../terraform1.pem") # Adjusted path to the PEM file
      host        = aws_eip.web_eip.public_ip
    }
  }
}

resource "aws_eip" "web_eip" {
  instance     = aws_instance.web.id
  allocation_id = "eipalloc-0a6ae38445bbcd1c4"  # <-- your existing EIP
  depends_on   = [aws_instance.web]
}
