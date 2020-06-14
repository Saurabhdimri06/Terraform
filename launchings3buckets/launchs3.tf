provider "aws" {
    region = "ap-south-1"
    profile = "saurabh"
}

resource "aws_s3_bucket" "mytestbucket125" {
  bucket = "mytestbucket456789" 
  acl    = "public-read"
  tags = {
    Name        = "testbucket456789" 
  }
  versioning {
	enabled =true
  }
}

resource "aws_s3_bucket_object" "s3object" {
  bucket = "${aws_s3_bucket.mytestbucket125.id}"
  key    = "Image6.png"
  source = "C:/Users/Saurabh/Downloads/Image6.png"
}
