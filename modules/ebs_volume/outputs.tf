output "id" {
  value = aws_ebs_volume.new_ebs_vol[*].id
}