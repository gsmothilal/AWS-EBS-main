resource "aws_instance" "vm" {
  ami               = var.ami_id
  instance_type     = var.instance_type
  availability_zone = var.availability_zone

  tags = {
    Name = "EBS-VM"
  }
}

resource "aws_ebs_volume" "volume" {
  availability_zone = var.availability_zone
  size              = var.volume_size
  type              = "gp3"

  tags = {
    Name = "ebs-volume"
  }
}

resource "aws_volume_attachment" "attach" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.volume.id
  instance_id = aws_instance.vm.id
}
