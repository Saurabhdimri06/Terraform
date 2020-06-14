provider "aws"{
    region = "ap-south-1"
    profile = "saurabh"
}

resource "aws_ebs_volume" "blockstorage" {
  availability_zone = "ap-south-1a"
  size              = 1

  tags = {
    Name = "TestVolume"
  }
}
