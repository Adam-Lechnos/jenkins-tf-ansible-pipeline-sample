resource "aws_volume_attachment" "ebs_attach" {
  count        = length(var.instance_id)
  device_name  = var.device_name
  volume_id    = var.ebs_volume_id[count.index]
  instance_id  = var.instance_id[count.index]
  skip_destroy = var.skip_destroy
  force_detach = var.force_detach
}
