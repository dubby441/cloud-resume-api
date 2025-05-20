# output "instance_ip" {
#   value = aws_instance.cloud_resume.public_ip
# }

output "ec2_static_ip" {
  value = aws_eip.eip.public_ip
}
