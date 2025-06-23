output "instance_id" {
  value = aws_instance.web.id
  description = "The ID of the EC2 instance"
}

output "instance_public_ip" {
  value = aws_eip.web_eip.public_ip
  description = "Elastic IP assigned to the EC2 instance"
}

output "instance_public_dns" {
  value = "http://${aws_eip.web_eip.public_ip}"
  description = "URL to access the server"
}
