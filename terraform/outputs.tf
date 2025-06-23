output "eip_public_ip" {
  description = "Elastic IP of the EC2 instance"
  value       = aws_eip.web_eip.public_ip
}
