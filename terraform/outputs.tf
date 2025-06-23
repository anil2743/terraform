output "public_dns" {
  value = "http://${aws_eip_association.eip_assoc.public_ip}"
  description = "Elastic IP for browser access"
}
