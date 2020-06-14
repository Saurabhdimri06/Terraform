provider "aws"{
	region     = "ap-south-1"
	profile    = "saurabh"
}

resource "aws_volume_attachment" "ebs_attach" {
  device_name = "/dev/sdh"
  volume_id   = "${aws_ebs_volume.examplevolume.id}"
  instance_id = "${aws_instance.basicOs2.id}"
  force_detach = true
}

resource "aws_instance" "basicOs2" {
  ami           = "ami-0447a12f28fddb066"
  instance_type = "t2.micro"
  key_name      = "basicKey_saurabh"
  security_groups = ["basicSecurity"]
  tags = {
    Name = "secondOS"
  }
}

resource "aws_ebs_volume" "examplevolume" {
  availability_zone = "ap-south-1a"
  size              = 1
  tags = {
    Name = "VolumeAttach"
  }
}
