output "ami_id" {
  value = data.aws_ami.centos_ami.image_id
}