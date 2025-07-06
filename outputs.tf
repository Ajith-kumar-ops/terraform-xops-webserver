output "ec2_public_ip" {
  value = aws_instance.xops_ec2.public_ip
}

output "web_url" {
  value = "http://${aws_instance.xops_ec2.public_ip}"
}
