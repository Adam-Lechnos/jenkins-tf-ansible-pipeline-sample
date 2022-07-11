resource "aws_ebs_volume" "new_ebs_vol" {
  count             = length(var.availability_zone)
  availability_zone = var.availability_zone[count.index]
  size              = var.ebs_volume_size
  type              = var.ebs_volume_type
  encrypted         = var.enable_encrypted
  tags              = merge(var.tags)
}