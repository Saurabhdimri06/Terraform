provider "aws"{
	region     = "ap-south-1"
	profile    = "saurabh"
}

resource "aws_instance" "basicOs" {
  ami           = "ami-0447a12f28fddb066"
  instance_type = "t2.micro"
  key_name      = "basicKey_saurabh"
  security_groups = ["basicSecurity"]
  tags = {
    Name = "firstOS"
  }
}
