output "id" {
  value = aws_instance.new_ec2_instance[*].id
}

output "az" {
  value = aws_instance.new_ec2_instance[*].availability_zone
}

output "subnet_id" {
  value = aws_instance.new_ec2_instance[*].subnet_id
}
