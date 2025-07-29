output "instance_id" {
  value = aws_instance.vm.id
}

output "ebs_volume_id" {
  value = aws_ebs_volume.volume.id
}